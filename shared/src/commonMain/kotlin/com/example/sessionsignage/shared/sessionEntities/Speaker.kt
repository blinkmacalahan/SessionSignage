package com.example.sessionsignage.shared.sessionEntities


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class Speaker(
    @SerialName("company")
    val company: String,
    @SerialName("description")
    val description: String,
    @SerialName("img")
    val img: String,
    @SerialName("name")
    val name: String,
    @SerialName("socialLinks")
    val socialLinks: List<SocialLink>
)