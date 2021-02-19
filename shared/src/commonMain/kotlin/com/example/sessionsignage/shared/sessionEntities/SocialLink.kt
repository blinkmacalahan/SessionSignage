package com.example.sessionsignage.shared.sessionEntities


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class SocialLink(
    @SerialName("name")
    val name: String,
    @SerialName("url")
    val url: String
)