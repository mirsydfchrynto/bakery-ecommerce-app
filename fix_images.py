import re

file_path = "backend/src/main/kotlin/com/bakery/ecommerce/config/DatabaseSeeder.kt"
with open(file_path, "r") as f:
    content = f.read()

def repl(match):
    name = match.group(1)
    desc = match.group(2)
    price = match.group(3)
    seed = name.replace(' ', '').replace("'", "")
    new_url = f"https://picsum.photos/seed/{seed}/800/800"
    return f'ProductData("{name}", "{desc}", {price}, "{new_url}")'

# Match ProductData("Name", "Desc", price, "URL")
pattern = r'ProductData\("([^"]+)",\s*"([^"]+)",\s*([0-9.]+),\s*"[^"]+"\)'
new_content = re.sub(pattern, repl, content)

with open(file_path, "w") as f:
    f.write(new_content)

print("Images replaced successfully!")
