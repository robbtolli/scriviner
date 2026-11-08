package com.tollitech.scrivener.widgets

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.Button
import android.widget.ListView
import android.widget.TextView
import com.tollitech.scrivener.MainActivity
import com.tollitech.scrivener.R
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

data class CharacterWidgetOption(
    val id: String,
    val name: String,
    val classLevel: String,
    val currentHp: Int,
    val maxHp: Int
)

class CharacterWidgetConfigureActivity : Activity() {

    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Default to CANCELED so if the user backs out, the widget is not created.
        setResult(RESULT_CANCELED)

        setContentView(R.layout.activity_character_widget_configure)

        appWidgetId = intent?.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: intent?.extras?.getInt(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID

        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }

        val characters = try {
            loadCharacters()
        } catch (_: Exception) {
            emptyList()
        }

        val listView = findViewById<ListView>(R.id.character_list)
        val emptyContainer = findViewById<View>(R.id.empty_state_container)
        val openAppButton = findViewById<Button>(R.id.btn_open_scrivener)

        if (characters.isEmpty()) {
            listView?.visibility = View.GONE
            emptyContainer?.visibility = View.VISIBLE
            openAppButton?.setOnClickListener {
                startActivity(Intent(this, MainActivity::class.java))
                finish()
            }
        } else {
            listView?.visibility = View.VISIBLE
            emptyContainer?.visibility = View.GONE

            val adapter = CharacterSelectAdapter(this, characters)
            listView?.adapter = adapter
            listView?.setOnItemClickListener { _, _, position, _ ->
                val selected = characters[position]
                selectCharacter(selected)
            }
        }
    }

    private fun selectCharacter(character: CharacterWidgetOption) {
        val widgetData = HomeWidgetPlugin.getData(this)
        val editor = widgetData.edit()

        editor.putString("character_widget_${appWidgetId}_id", character.id)
        editor.putString("character_${character.id}_name", character.name)
        editor.putString("character_${character.id}_class_level", character.classLevel)
        editor.putInt("character_${character.id}_current_hp", character.currentHp)
        editor.putInt("character_${character.id}_max_hp", character.maxHp)
        editor.apply()

        val appWidgetManager = AppWidgetManager.getInstance(this)
        CharacterWidgetProvider.updateWidget(this, appWidgetManager, appWidgetId, widgetData)

        val resultValue = Intent().apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        }
        setResult(RESULT_OK, resultValue)
        finish()
    }

    private fun loadCharacters(): List<CharacterWidgetOption> {
        val widgetData = HomeWidgetPlugin.getData(this)
        val jsonString = widgetData.getString("character_summary_list", null)
            ?: widgetData.getString("flutter.character_summary_list", null)

        if (!jsonString.isNullOrEmpty()) {
            try {
                val list = mutableListOf<CharacterWidgetOption>()
                val array = JSONArray(jsonString)
                for (i in 0 until array.length()) {
                    val obj = array.getJSONObject(i)
                    list.add(
                        CharacterWidgetOption(
                            id = obj.optString("id", ""),
                            name = obj.optString("name", "Unnamed Hero"),
                            classLevel = obj.optString("classLevel", "Adventurer"),
                            currentHp = obj.optInt("currentHp", 10),
                            maxHp = obj.optInt("maxHp", 10)
                        )
                    )
                }
                if (list.isNotEmpty()) return list
            } catch (_: Exception) {
                // Fall back to SQLite database inspection
            }
        }

        // SQLite Fallback
        return loadCharactersFromDatabase()
    }

    private fun loadCharactersFromDatabase(): List<CharacterWidgetOption> {
        val candidates = mutableListOf<File>()
        candidates.add(File(filesDir, "scrivener_db.sqlite"))
        candidates.add(File(filesDir, "app_flutter/scrivener_db.sqlite"))
        getDatabasePath("scrivener_db.sqlite")?.let { candidates.add(it) }
        filesDir.parentFile?.let { parent ->
            candidates.add(File(parent, "app_flutter/scrivener_db.sqlite"))
            candidates.add(File(parent, "databases/scrivener_db.sqlite"))
        }

        val dbFile = candidates.firstOrNull { it.exists() } ?: return emptyList()

        val list = mutableListOf<CharacterWidgetOption>()
        var db: SQLiteDatabase? = null
        try {
            db = SQLiteDatabase.openDatabase(dbFile.path, null, SQLiteDatabase.OPEN_READONLY)
            val cursor = db.rawQuery(
                "SELECT id, name, raw_properties_json FROM characters_table ORDER BY last_played_at DESC",
                null
            )
            cursor.use { c ->
                val idIdx = c.getColumnIndex("id")
                val nameIdx = c.getColumnIndex("name")
                val propsIdx = c.getColumnIndex("raw_properties_json")

                while (c.moveToNext()) {
                    val id = if (idIdx >= 0) c.getString(idIdx) else ""
                    val name = if (nameIdx >= 0) c.getString(nameIdx) else "Hero"
                    val propsJson = if (propsIdx >= 0) c.getString(propsIdx) else "{}"

                    var classLevel = "Adventurer"
                    var currentHp = 10
                    var maxHp = 10

                    try {
                        val json = JSONObject(propsJson)
                        val className = json.optString("className", json.optString("class", ""))
                        val raceName = json.optString("race", "")
                        val level = json.optInt("level", 1)
                        currentHp = json.optInt("currentHp", json.optInt("hp", 10))
                        maxHp = json.optInt("maxHp", currentHp.coerceAtLeast(10))

                        classLevel = buildString {
                            if (raceName.isNotEmpty()) append("$raceName • ")
                            if (className.isNotEmpty()) append("$className $level")
                            else append("Level $level")
                        }
                    } catch (_: Exception) { }

                    list.add(
                        CharacterWidgetOption(
                            id = id,
                            name = name,
                            classLevel = classLevel,
                            currentHp = currentHp,
                            maxHp = maxHp
                        )
                    )
                }
            }
        } catch (_: Exception) {
            // Return any characters found so far
        } finally {
            db?.close()
        }

        return list
    }

    private class CharacterSelectAdapter(
        private val context: Context,
        private val items: List<CharacterWidgetOption>
    ) : BaseAdapter() {

        override fun getCount(): Int = items.size
        override fun getItem(position: Int): Any = items[position]
        override fun getItemId(position: Int): Long = position.toLong()

        override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
            val view = convertView ?: LayoutInflater.from(context)
                .inflate(R.layout.item_character_select, parent, false)

            val item = items[position]
            val nameView = view.findViewById<TextView>(R.id.item_character_name)
            val subView = view.findViewById<TextView>(R.id.item_character_subtitle)
            val hpView = view.findViewById<TextView>(R.id.item_character_hp)

            nameView.text = item.name
            subView.text = item.classLevel
            hpView.text = "HP ${item.currentHp}/${item.maxHp}"

            return view
        }
    }
}
