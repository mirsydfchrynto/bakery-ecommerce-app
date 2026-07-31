package com.bakery.ecommerce.domain.storage.service

import com.bakery.ecommerce.exception.BusinessException
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider
import software.amazon.awssdk.core.sync.RequestBody
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.PutObjectRequest
import java.util.UUID

@Service
@ConditionalOnProperty(name = ["storage.type"], havingValue = "s3")
class AwsS3StorageService(
    @Value("\${storage.s3.bucket}") private val bucketName: String,
    @Value("\${storage.s3.region}") private val region: String
) : StorageService {

    // Lazy initialization so the app doesn't crash on startup if credentials aren't present
    // but the bean is somehow initialized.
    private val s3Client: S3Client by lazy {
        S3Client.builder()
            .region(Region.of(region))
            .credentialsProvider(DefaultCredentialsProvider.create())
            .build()
    }

    override fun uploadFile(file: MultipartFile): String {
        try {
            val extension = file.originalFilename?.substringAfterLast(".", "bin") ?: "bin"
            val fileName = "${UUID.randomUUID()}.$extension"

            val putObjectRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(fileName)
                .contentType(file.contentType)
                .build()

            s3Client.putObject(putObjectRequest, RequestBody.fromInputStream(file.inputStream, file.size))

            // Assuming public read access or a CloudFront distribution
            return "https://$bucketName.s3.$region.amazonaws.com/$fileName"
        } catch (e: Exception) {
            throw BusinessException("STORAGE-001", "Failed to upload file to S3: ${e.message}")
        }
    }

    override fun uploadFiles(files: List<MultipartFile>): List<String> {
        return files.map { uploadFile(it) }
    }
}
