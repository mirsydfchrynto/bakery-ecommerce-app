package com.bakery.ecommerce.domain.storage.controller

import com.bakery.ecommerce.exception.BaseResponse
import com.bakery.ecommerce.domain.storage.service.StorageService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile

@RestController
@RequestMapping("/api/v1/storage")
@Tag(name = "Storage", description = "Endpoints for generic file uploads (Images, Documents)")
@SecurityRequirement(name = "bearerAuth")
class StorageController(private val storageService: StorageService) {

    @PostMapping(value = ["/upload"], consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
    @Operation(summary = "Upload a single file and get its URL")
    fun uploadFile(
        @RequestPart("file") file: MultipartFile
    ): ResponseEntity<BaseResponse<Map<String, String>>> {
        val url = storageService.uploadFile(file)
        return ResponseEntity.ok(BaseResponse.success(mapOf("url" to url), "File uploaded successfully"))
    }
}
