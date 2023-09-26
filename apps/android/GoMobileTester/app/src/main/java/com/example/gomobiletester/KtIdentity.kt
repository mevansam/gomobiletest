package com.example.gomobiletester

import person.Identity

class KtIdentity : Identity {
    private var username: String = ""

    constructor(username: String) {
        this.username = username
    }

    override fun username(): String {
        return this.username
    }
}
