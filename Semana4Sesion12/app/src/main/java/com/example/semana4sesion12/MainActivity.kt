package com.example.semana4sesion12

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast

class MainActivity : AppCompatActivity() {

    lateinit var questions: ArrayList<Question>
    var position = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        loadQuestions()
        setupViews()

    }

    private fun loadQuestions() {
        questions = ArrayList()
        var question = Question("¿Es Lima capital de Perú?", true)
        questions.add(question)
        questions.add(Question("¿Es el Sol una estrella?", true))
        questions.add(Question("¿La Tierra gira alrededor del Sol?", true))
        questions.add(Question("¿El agua hierve a 100 grados Celsius?", true))
        questions.add(Question("¿El oxígeno es un gas necesario para la respiración?", true))
        questions.add(Question("¿La Gran Muralla China es visible desde el espacio?", false))

    }

    private fun setupViews(){
        val btYes = findViewById<Button>(R.id.btYes)
        val btFalse = findViewById<Button>(R.id.btFalse)
        val btNext = findViewById<Button>(R.id.btNext)
        val tvQuestion = findViewById<TextView>(R.id.tvQuestion)

        tvQuestion.text = questions[position].sentence

        btYes.setOnClickListener {
            if(questions[position].answer == true)
                Toast.makeText(this,"Rpta correcta", Toast.LENGTH_LONG).show()
            else
                Toast.makeText(this,"Rpta incorrecta", Toast.LENGTH_LONG).show()
        }

        btFalse.setOnClickListener {
            if(questions[position].answer == false)
                Toast.makeText(this,"Rpta correcta", Toast.LENGTH_LONG).show()
            else
                Toast.makeText(this,"Rpta incorrecta", Toast.LENGTH_LONG).show()
        }

        btNext.setOnClickListener {
            position++
            tvQuestion.text = questions[position].sentence
        }

    }
}