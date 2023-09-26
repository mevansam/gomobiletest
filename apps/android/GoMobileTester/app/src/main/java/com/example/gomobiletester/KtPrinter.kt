package com.example.gomobiletester

import android.util.Log
import greeter.Printer

class KtPrinter : Printer {
    override fun printSomething(s: String) {
        Log.d("App", "This just in: $s")
    }
}
