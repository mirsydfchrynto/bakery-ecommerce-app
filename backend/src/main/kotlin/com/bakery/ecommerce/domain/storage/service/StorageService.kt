package com.bakery.ecommerce.domain.storage.service

import org.springframework.web.multipart.MultipartFile

interface StorageService {
    fun uploadFile(file: MultipartFile): String
    fun uploadFiles(files: List<MultipartFile>): List<String>
}
