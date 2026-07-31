package com.bakery.ecommerce.domain.storage.service

import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.nio.file.Files
import java.nio.file.Paths
import java.nio.file.StandardCopyOption
import java.util.UUID

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty

@Service
@ConditionalOnProperty(name = ["storage.type"], havingValue = "local", matchIfMissing = true)
class LocalFileStorageService : StorageService {
    private val uploadDir = "uploads"

    private val allowedExtensions = listOf("jpg", "jpeg", "png")
    private val allowedContentTypes = listOf("image/jpeg", "image/png")

    init {
        Files.createDirectories(Paths.get(uploadDir))
    }

    override fun uploadFile(file: MultipartFile): String {
        val originalFilename = file.originalFilename ?: throw IllegalArgumentException("Filename cannot be null")
        val extension = originalFilename.substringAfterLast('.', "").lowercase()
        
        if (extension !in allowedExtensions) {
            throw IllegalArgumentException("File extension not allowed. Only JPG, JPEG, and PNG are supported.")
        }
        
        if (file.contentType !in allowedContentTypes) {
            throw IllegalArgumentException("Invalid content type. Only images are allowed.")
        }

        val fileName = "${UUID.randomUUID()}_${originalFilename.replace(" ", "_")}"
        val filePath = Paths.get(uploadDir, fileName)
        Files.copy(file.inputStream, filePath, StandardCopyOption.REPLACE_EXISTING)
        return "/uploads/$fileName"
    }

    override fun uploadFiles(files: List<MultipartFile>): List<String> {
        return files.map { uploadFile(it) }
    }
}
