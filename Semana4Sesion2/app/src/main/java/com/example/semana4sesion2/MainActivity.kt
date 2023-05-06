package com.example.semana4sesion2

import android.content.pm.PackageManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

val CAMERA_REQUEST_CODE = 0

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val btCamera = findViewById<Button>(R.id.btCamara)

        btCamera.setOnClickListener {
            checkCameraPermission()
        }

    }

    private fun checkCameraPermission() {
        if(ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) !=
                PackageManager.PERMISSION_GRANTED){
            requestCameraPermission()
        }
        else{
            Toast.makeText(this, "Ya se tiene el permiso de la camara", Toast.LENGTH_LONG).show()
        }
    }

    private fun requestCameraPermission() {
        if(ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.CAMERA)){
            Toast.makeText(this, "Rechazó el permiso antes. Habilitalo pue", Toast.LENGTH_LONG).show()
        }
        else{
            Toast.makeText(this, "Debe de aceptar el permiso", Toast.LENGTH_LONG).show()
            ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.CAMERA), CAMERA_REQUEST_CODE)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when(requestCode){
            CAMERA_REQUEST_CODE -> {
                if(grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED){
                    Toast.makeText(this, "Se acepto el permiso de la camara", Toast.LENGTH_LONG).show()
                }
                else{
                    Toast.makeText(this, "Permiso negado", Toast.LENGTH_LONG).show()
                }
                return
            }
        }
    }
}