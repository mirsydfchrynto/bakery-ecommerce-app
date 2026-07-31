package com.bakery.ecommerce.common

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.NoRepositoryBean
import java.util.UUID

@NoRepositoryBean
interface BaseRepository<T : BaseEntity> : JpaRepository<T, UUID>
