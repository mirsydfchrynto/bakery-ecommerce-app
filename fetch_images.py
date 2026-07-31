from duckduckgo_search import DDGS
import re
import time

with open('backend/src/main/kotlin/com/bakery/ecommerce/config/DatabaseSeeder.kt', 'r') as f:
    content = f.read()

products = re.findall(r'ProductData\("([^"]+)"', content)

print("val productImages = mapOf(")
with DDGS() as ddgs:
    for p in products:
        try:
            results = list(ddgs.images(p + " bakery", max_results=1))
            if results:
                print(f'    "{p}" to "{results[0]["image"]}",')
            else:
                print(f'    "{p}" to "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&h=800&fit=crop&q=80",')
        except Exception as e:
            print(f'    "{p}" to "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&h=800&fit=crop&q=80",')
        time.sleep(0.2)
print(")")
