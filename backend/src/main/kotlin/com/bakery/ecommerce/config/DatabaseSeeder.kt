package com.bakery.ecommerce.config

import com.bakery.ecommerce.domain.catalog.Category
import com.bakery.ecommerce.domain.catalog.CategoryRepository
import com.bakery.ecommerce.domain.catalog.Product
import com.bakery.ecommerce.domain.catalog.ProductImage
import com.bakery.ecommerce.domain.catalog.ProductImageRepository
import com.bakery.ecommerce.domain.catalog.ProductRepository
import com.bakery.ecommerce.domain.catalog.ProductStatus
import com.bakery.ecommerce.domain.iam.Role
import com.bakery.ecommerce.domain.iam.RoleRepository
import com.bakery.ecommerce.domain.iam.User
import com.bakery.ecommerce.domain.iam.UserRepository
import com.bakery.ecommerce.domain.inventory.Inventory
import com.bakery.ecommerce.domain.inventory.InventoryRepository
import com.bakery.ecommerce.domain.inventory.InventoryStatus
import org.springframework.boot.CommandLineRunner
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal

@Component
class DatabaseSeeder(
    private val userRepository: UserRepository,
    private val roleRepository: RoleRepository,
    private val passwordEncoder: PasswordEncoder,
    private val categoryRepository: CategoryRepository,
    private val productRepository: ProductRepository,
    private val productImageRepository: ProductImageRepository,
    private val inventoryRepository: InventoryRepository,
    private val orderRepository: com.bakery.ecommerce.domain.order.OrderRepository
) : CommandLineRunner {

    @Transactional
    override fun run(vararg args: String) {
        seedRolesAndUsers()
        seedProducts()
        seedOrders()
    }

    private fun seedRolesAndUsers() {
        if (roleRepository.count() == 0L) {
            val adminRole = Role().apply { roleName = "ADMIN"; description = "Administrator role with full access" }
            val customerRole = Role().apply { roleName = "CUSTOMER"; description = "Default customer role" }
            roleRepository.saveAll(listOf(adminRole, customerRole))

            if (userRepository.count() == 0L) {
                val adminUser = User().apply {
                    username = "irsyad"
                    passwordHash = passwordEncoder.encode("irsyad1805")!!
                    role = adminRole
                    email = "admin@bakery.com"
                    phoneNumber = "+6281234567890"
                }
                val customerUser = User().apply {
                    username = "customer"
                    passwordHash = passwordEncoder.encode("customer123")!!
                    role = customerRole
                    email = "customer@bakery.com"
                    phoneNumber = "+6281234567891"
                }
                userRepository.saveAll(listOf(adminUser, customerUser))
            }
        }
    }

    private fun seedProducts() {
        if (productRepository.count() == 0L) {
            val breadsCategory = categoryRepository.save(Category().apply { name = "Breads"; slug = "breads" })
            val cakesCategory = categoryRepository.save(Category().apply { name = "Cakes"; slug = "cakes" })
            val cookiesCategory = categoryRepository.save(Category().apply { name = "Cookies"; slug = "cookies" })
            val drinksCategory = categoryRepository.save(Category().apply { name = "Drinks"; slug = "drinks" })

            val breads = listOf(
                ProductData("Classic French Baguette", "Crispy crust on the outside, soft and airy crumb on the inside. Baked fresh daily.", 25000.0, "https://picsum.photos/seed/ClassicFrenchBaguette/800/800"),
                ProductData("Sourdough Boule", "Artisan naturally fermented bread with a signature tangy flavor and chewy texture.", 45000.0, "https://picsum.photos/seed/SourdoughBoule/800/800"),
                ProductData("Butter Croissant", "Flaky, buttery, and golden brown French pastry. Perfect for breakfast.", 20000.0, "https://picsum.photos/seed/ButterCroissant/800/800"),
                ProductData("Chocolate Babka", "Rich braided sweet bread filled with premium dark chocolate swirls.", 55000.0, "https://picsum.photos/seed/ChocolateBabka/800/800"),
                ProductData("Cinnamon Roll", "Soft and fluffy bread swirled with cinnamon sugar and topped with cream cheese frosting.", 25000.0, "https://picsum.photos/seed/CinnamonRoll/800/800"),
                ProductData("Whole Wheat Loaf", "Healthy and nutritious loaf made with 100% whole wheat flour.", 30000.0, "https://picsum.photos/seed/WholeWheatLoaf/800/800"),
                ProductData("Garlic Butter Bread", "Savory artisan bread generously loaded with roasted garlic and herb butter.", 35000.0, "https://picsum.photos/seed/GarlicButterBread/800/800"),
                ProductData("Rye Bread", "Dense, dark, and flavorful European style bread.", 40000.0, "https://picsum.photos/seed/RyeBread/800/800"),
                ProductData("Milk Toast Bread", "Japanese Shokupan, extremely fluffy and sweet milk bread loaf.", 35000.0, "https://picsum.photos/seed/MilkToastBread/800/800"),
                ProductData("Almond Croissant", "Twice-baked croissant filled and topped with sweet almond frangipane.", 30000.0, "https://picsum.photos/seed/AlmondCroissant/800/800"),
                ProductData("Pretzel", "Authentic Bavarian soft pretzel sprinkled with coarse sea salt.", 22000.0, "https://picsum.photos/seed/Pretzel/800/800"),
                ProductData("Ciabatta", "Rustic Italian bread with a porous crumb, perfect for gourmet panini.", 25000.0, "https://picsum.photos/seed/Ciabatta/800/800"),
                ProductData("Cheese Focaccia", "Italian flatbread baked with olive oil, herbs, and melted cheddar.", 38000.0, "https://picsum.photos/seed/CheeseFocaccia/800/800"),
                ProductData("Pain au Chocolat", "Classic French pastry filled with two batons of dark chocolate.", 24000.0, "https://picsum.photos/seed/PainauChocolat/800/800"),
                ProductData("Brioche Bun", "Rich, buttery, and soft bun, perfect for premium burgers or eating plain.", 18000.0, "https://picsum.photos/seed/BriocheBun/800/800"),
                ProductData("Bagel with Cream Cheese", "New York style boiled bagel served with a side of cream cheese.", 30000.0, "https://picsum.photos/seed/BagelwithCreamCheese/800/800"),
                ProductData("Multigrain Bread", "Packed with sunflower seeds, flaxseeds, and oats for a healthy diet.", 42000.0, "https://picsum.photos/seed/MultigrainBread/800/800"),
                ProductData("Olive Bread", "Artisan loaf studded with Kalamata olives and rosemary.", 45000.0, "https://picsum.photos/seed/OliveBread/800/800"),
                ProductData("Pumpernickel", "Dark, slightly sweet and dense German sourdough bread.", 40000.0, "https://picsum.photos/seed/Pumpernickel/800/800"),
                ProductData("Cheese Babka", "Savory braided bread generously filled with sharp cheddar and parmesan.", 55000.0, "https://picsum.photos/seed/CheeseBabka/800/800")
            )

            val cakes = listOf(
                ProductData("Classic Red Velvet Cake", "Moist layers of red velvet cake filled and topped with cream cheese frosting.", 350000.0, "https://picsum.photos/seed/ClassicRedVelvetCake/800/800"),
                ProductData("Dark Chocolate Truffle Cake", "Rich, decadent chocolate sponge layered with smooth chocolate ganache.", 400000.0, "https://picsum.photos/seed/DarkChocolateTruffleCake/800/800"),
                ProductData("New York Cheesecake", "Creamy, dense baked cheesecake with a buttery graham cracker crust.", 380000.0, "https://picsum.photos/seed/NewYorkCheesecake/800/800"),
                ProductData("Matcha Mille Crepe", "20 layers of paper-thin crepes filled with premium Uji matcha cream.", 420000.0, "https://picsum.photos/seed/MatchaMilleCrepe/800/800"),
                ProductData("Strawberry Shortcake", "Light vanilla sponge layered with fresh strawberries and whipped cream.", 320000.0, "https://picsum.photos/seed/StrawberryShortcake/800/800"),
                ProductData("Tiramisu Cake", "Coffee-soaked ladyfingers layered with a light mascarpone cream.", 360000.0, "https://picsum.photos/seed/TiramisuCake/800/800"),
                ProductData("Lemon Pound Cake", "Zesty, buttery loaf cake topped with a sweet lemon glaze.", 120000.0, "https://picsum.photos/seed/LemonPoundCake/800/800"),
                ProductData("Black Forest", "Classic cherry and chocolate layered cake with whipped cream.", 350000.0, "https://picsum.photos/seed/BlackForest/800/800"),
                ProductData("Carrot Cake", "Spiced cake loaded with carrots and walnuts, frosted with cream cheese.", 340000.0, "https://picsum.photos/seed/CarrotCake/800/800"),
                ProductData("Opera Cake", "Elegant French cake with layers of almond sponge, coffee syrup, and chocolate.", 450000.0, "https://picsum.photos/seed/OperaCake/800/800"),
                ProductData("Mango Mousse Cake", "Light, tropical, and refreshing mango mousse on a sponge base.", 330000.0, "https://picsum.photos/seed/MangoMousseCake/800/800"),
                ProductData("Earl Grey Chiffon", "Extremely fluffy chiffon cake infused with fragrant Earl Grey tea.", 280000.0, "https://picsum.photos/seed/EarlGreyChiffon/800/800"),
                ProductData("Blueberry Cheesecake", "Rich baked cheesecake topped with homemade blueberry compote.", 390000.0, "https://picsum.photos/seed/BlueberryCheesecake/800/800"),
                ProductData("Vanilla Bean Sponge", "Classic, simple, and elegant vanilla cake made with real vanilla beans.", 250000.0, "https://picsum.photos/seed/VanillaBeanSponge/800/800"),
                ProductData("Caramel Macchiato Cake", "Coffee infused cake layers with salted caramel buttercream.", 370000.0, "https://picsum.photos/seed/CaramelMacchiatoCake/800/800"),
                ProductData("Raspberry Tart", "Sweet pastry crust filled with custard and topped with fresh raspberries.", 220000.0, "https://picsum.photos/seed/RaspberryTart/800/800"),
                ProductData("Pandan Gula Melaka Cake", "Local favorite pandan cake layered with palm sugar and coconut.", 300000.0, "https://picsum.photos/seed/PandanGulaMelakaCake/800/800"),
                ProductData("Hazelnut Praline Cake", "Nutty and rich layered cake with crunchy hazelnut praline.", 410000.0, "https://picsum.photos/seed/HazelnutPralineCake/800/800"),
                ProductData("Choco Mint Cake", "Refreshing peppermint frosting layered between rich dark chocolate cake.", 360000.0, "https://picsum.photos/seed/ChocoMintCake/800/800"),
                ProductData("Lotus Biscoff Cheesecake", "New York cheesecake infused and topped with Speculoos cookie butter.", 400000.0, "https://picsum.photos/seed/LotusBiscoffCheesecake/800/800")
            )

            val cookies = listOf(
                ProductData("Chocolate Chip Cookie", "Chewy edge, soft center, and loaded with gooey dark chocolate chips.", 15000.0, "https://picsum.photos/seed/ChocolateChipCookie/800/800"),
                ProductData("Double Chocolate Cookie", "The ultimate chocolate lover's dream with cocoa dough and chocolate chunks.", 18000.0, "https://picsum.photos/seed/DoubleChocolateCookie/800/800"),
                ProductData("Macadamia White Choco", "Sweet white chocolate chips paired with crunchy roasted macadamia nuts.", 22000.0, "https://picsum.photos/seed/MacadamiaWhiteChoco/800/800"),
                ProductData("Oatmeal Raisin Cookie", "Chewy, comforting, and perfectly spiced with cinnamon and plump raisins.", 15000.0, "https://picsum.photos/seed/OatmealRaisinCookie/800/800"),
                ProductData("Red Velvet Cookie", "Vibrant red velvet dough studded with creamy white chocolate chips.", 18000.0, "https://picsum.photos/seed/RedVelvetCookie/800/800"),
                ProductData("Matcha Almond Cookie", "Earthy Japanese matcha flavor balanced with sliced toasted almonds.", 20000.0, "https://picsum.photos/seed/MatchaAlmondCookie/800/800"),
                ProductData("Peanut Butter Cookie", "Classic, crumbly, and rich peanut butter flavor with a fork-pressed top.", 16000.0, "https://picsum.photos/seed/PeanutButterCookie/800/800"),
                ProductData("Snickerdoodle", "Soft, pillowy cookie coated in a generous layer of cinnamon sugar.", 15000.0, "https://picsum.photos/seed/Snickerdoodle/800/800"),
                ProductData("Lotus Biscoff Stuffed", "Soft brown sugar cookie with a gooey melted Speculoos center.", 25000.0, "https://picsum.photos/seed/LotusBiscoffStuffed/800/800"),
                ProductData("S'mores Cookie", "Toasted marshmallow, graham cracker crumbs, and milk chocolate.", 24000.0, "https://picsum.photos/seed/SmoresCookie/800/800"),
                ProductData("Nutella Sea Salt", "Thick cookie stuffed with Nutella and sprinkled with flaky sea salt.", 25000.0, "https://picsum.photos/seed/NutellaSeaSalt/800/800"),
                ProductData("Lemon Glaze Cookie", "Zesty soft baked lemon cookie topped with a sweet citrus glaze.", 17000.0, "https://picsum.photos/seed/LemonGlazeCookie/800/800"),
                ProductData("Espresso Chocolate Cookie", "Coffee infused cookie dough loaded with dark chocolate chunks.", 19000.0, "https://picsum.photos/seed/EspressoChocolateCookie/800/800"),
                ProductData("Shortbread Cookie", "Buttery, crumbly, and melt-in-your-mouth Scottish classic.", 14000.0, "https://picsum.photos/seed/ShortbreadCookie/800/800"),
                ProductData("Pistachio Cranberry", "Festive and nutty cookie with bright dried cranberries.", 22000.0, "https://picsum.photos/seed/PistachioCranberry/800/800"),
                ProductData("Brownie Cookie", "Brookies - half fudgy brownie, half chewy chocolate chip cookie.", 20000.0, "https://picsum.photos/seed/BrownieCookie/800/800"),
                ProductData("Funfetti Sugar Cookie", "Soft and chewy sugar cookie baked with colorful rainbow sprinkles.", 15000.0, "https://picsum.photos/seed/FunfettiSugarCookie/800/800"),
                ProductData("Ginger Molasses Cookie", "Chewy, richly spiced cookie with deep molasses and ginger flavors.", 16000.0, "https://picsum.photos/seed/GingerMolassesCookie/800/800"),
                ProductData("Coconut Macaroon", "Chewy coconut drops, baked until golden and dipped in dark chocolate.", 18000.0, "https://picsum.photos/seed/CoconutMacaroon/800/800"),
                ProductData("Almond Biscotti", "Crunchy twice-baked Italian cookie, perfect for dipping in coffee.", 20000.0, "https://picsum.photos/seed/AlmondBiscotti/800/800")
            )

            val drinks = listOf(
                ProductData("Hot Caffe Latte", "Smooth and balanced espresso combined with perfectly steamed milk.", 35000.0, "https://picsum.photos/seed/HotCaffeLatte/800/800"),
                ProductData("Iced Americano", "Chilled espresso poured over ice and water. Bold and refreshing.", 28000.0, "https://picsum.photos/seed/IcedAmericano/800/800"),
                ProductData("Caramel Macchiato", "Espresso layered with vanilla, milk, and a sweet caramel drizzle.", 45000.0, "https://picsum.photos/seed/CaramelMacchiato/800/800"),
                ProductData("Matcha Latte", "Premium Japanese Uji matcha green tea blended with steamed milk.", 40000.0, "https://picsum.photos/seed/MatchaLatte/800/800"),
                ProductData("Iced Chocolate", "Rich and creamy Belgian chocolate served over ice.", 38000.0, "https://picsum.photos/seed/IcedChocolate/800/800"),
                ProductData("Hazelnut Latte", "Nutty, sweet hazelnut syrup mixed with classic espresso and milk.", 42000.0, "https://picsum.photos/seed/HazelnutLatte/800/800"),
                ProductData("Vanilla Bean Frappe", "Ice blended beverage made with real vanilla bean and topped with cream.", 45000.0, "https://picsum.photos/seed/VanillaBeanFrappe/800/800"),
                ProductData("Mocha Latte", "The perfect blend of robust espresso and rich dark chocolate sauce.", 42000.0, "https://picsum.photos/seed/MochaLatte/800/800"),
                ProductData("Cold Brew Coffee", "Steeped slowly for 18 hours for a smooth, low-acid coffee experience.", 35000.0, "https://picsum.photos/seed/ColdBrewCoffee/800/800"),
                ProductData("Earl Grey Milk Tea", "Fragrant Earl Grey black tea brewed and mixed with creamy milk.", 32000.0, "https://picsum.photos/seed/EarlGreyMilkTea/800/800"),
                ProductData("Peach Iced Tea", "Refreshing black tea infused with natural peach flavor and fruit slices.", 28000.0, "https://picsum.photos/seed/PeachIcedTea/800/800"),
                ProductData("Strawberry Smoothie", "Freshly blended strawberries and creamy yogurt.", 40000.0, "https://picsum.photos/seed/StrawberrySmoothie/800/800"),
                ProductData("Mango Tango Frappe", "Tropical and sweet mango blended drink, perfect for a hot day.", 42000.0, "https://picsum.photos/seed/MangoTangoFrappe/800/800"),
                ProductData("Flat White", "Double ristretto shot finished with velvety micro-foamed milk.", 38000.0, "https://picsum.photos/seed/FlatWhite/800/800"),
                ProductData("Dirty Matcha", "Iced matcha latte topped with a bold shot of espresso.", 48000.0, "https://picsum.photos/seed/DirtyMatcha/800/800"),
                ProductData("Affogato", "A shot of hot espresso poured over a scoop of premium vanilla ice cream.", 45000.0, "https://picsum.photos/seed/Affogato/800/800"),
                ProductData("Lychee Yakult", "Sweet and tangy probiotic drink mixed with lychee syrup and jelly.", 30000.0, "https://picsum.photos/seed/LycheeYakult/800/800"),
                ProductData("Chai Tea Latte", "Spiced Indian black tea with notes of cinnamon, cardamom, and milk.", 38000.0, "https://picsum.photos/seed/ChaiTeaLatte/800/800"),
                ProductData("Sparkling Lemonade", "Freshly squeezed lemon juice mixed with bubbly sparkling water.", 25000.0, "https://picsum.photos/seed/SparklingLemonade/800/800"),
                ProductData("Red Velvet Latte", "Creamy, sweet, and cake-inspired warm drink topped with cocoa powder.", 40000.0, "https://picsum.photos/seed/RedVelvetLatte/800/800")
            )

            val breadImages = listOf(
                "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=80",
                "https://images.unsplash.com/photo-1598373182133-52452f7691ef?w=800&q=80",
                "https://images.unsplash.com/photo-1589367920969-ab8e050bfc19?w=800&q=80",
                "https://images.unsplash.com/photo-1608198093002-ad4e005484ec?w=800&q=80",
                "https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800&q=80"
            )
            val cakeImages = listOf(
                "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800&q=80",
                "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=800&q=80",
                "https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=800&q=80",
                "https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?w=800&q=80",
                "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800&q=80"
            )
            val cookieImages = listOf(
                "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=800&q=80",
                "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=800&q=80",
                "https://images.unsplash.com/photo-1618923850106-920f26284dc8?w=800&q=80",
                "https://images.unsplash.com/photo-1590080875516-ceea27328400?w=800&q=80",
                "https://images.unsplash.com/photo-1557089706-68d022b4cbab?w=800&q=80"
            )
            val drinkImages = listOf(
                "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800&q=80",
                "https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=800&q=80",
                "https://images.unsplash.com/photo-1541167760496-1628856ab772?w=800&q=80",
                "https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800&q=80",
                "https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=800&q=80"
            )

            breads.forEachIndexed { index, it -> createAndSaveProduct(it.copy(imageUrl = breadImages[index % breadImages.size]), breadsCategory) }
            cakes.forEachIndexed { index, it -> createAndSaveProduct(it.copy(imageUrl = cakeImages[index % cakeImages.size]), cakesCategory) }
            cookies.forEachIndexed { index, it -> createAndSaveProduct(it.copy(imageUrl = cookieImages[index % cookieImages.size]), cookiesCategory) }
            drinks.forEachIndexed { index, it -> createAndSaveProduct(it.copy(imageUrl = drinkImages[index % drinkImages.size]), drinksCategory) }
            
            println("✅ Seeded 80 highly curated premium bakery products.")
        }
    }

    private data class ProductData(val name: String, val desc: String, val price: Double, val imageUrl: String)

    private fun createAndSaveProduct(
        data: ProductData,
        category: Category
    ) {
        val product = Product().apply {
            this.name = data.name
            this.description = data.desc
            this.price = BigDecimal.valueOf(data.price)
            this.categories.add(category)
            this.status = ProductStatus.ACTIVE
        }
        val savedProduct = productRepository.save(product)

        val sanitizedName = data.name.replace(Regex("[^a-zA-Z]"), "").lowercase()
        val keyword = sanitizedName + "," + category.name.lowercase().removeSuffix("s")
        val aiImageUrl = "https://loremflickr.com/800/800/$keyword?lock=${savedProduct.id}"

        val image = ProductImage().apply {
            this.product = savedProduct
            this.url = aiImageUrl
            this.isPrimary = true
        }
        productImageRepository.save(image)

        val inventory = Inventory().apply {
            this.product = savedProduct
            this.stock = 150
            this.reservedStock = 0
            this.minimumStock = 10
            this.status = InventoryStatus.IN_STOCK
        }
        inventoryRepository.save(inventory)
    }

    private fun seedOrders() {
        if (orderRepository.count() == 0L) {
            val customer = userRepository.findByUsername("customer")
            val products = productRepository.findAll()

            if (customer != null && products.isNotEmpty()) {
                val order1 = com.bakery.ecommerce.domain.order.Order().apply {
                    this.customer = customer
                    this.status = com.bakery.ecommerce.domain.order.OrderStatus.COMPLETED
                    this.totalAmount = products[0].price.add(products[1].price)
                }
                order1.items.add(com.bakery.ecommerce.domain.order.OrderItem().apply {
                    this.order = order1
                    this.product = products[0]
                    this.quantity = 1
                    this.priceAtPurchase = products[0].price
                })
                order1.items.add(com.bakery.ecommerce.domain.order.OrderItem().apply {
                    this.order = order1
                    this.product = products[1]
                    this.quantity = 1
                    this.priceAtPurchase = products[1].price
                })

                val order2 = com.bakery.ecommerce.domain.order.Order().apply {
                    this.customer = customer
                    this.status = com.bakery.ecommerce.domain.order.OrderStatus.PROCESSING
                    this.totalAmount = products[70].price.multiply(java.math.BigDecimal("3"))
                }
                order2.items.add(com.bakery.ecommerce.domain.order.OrderItem().apply {
                    this.order = order2
                    this.product = products[70]
                    this.quantity = 3
                    this.priceAtPurchase = products[70].price
                })

                orderRepository.saveAll(listOf(order1, order2))
            }
        }
    }
}
