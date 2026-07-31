import os
import re

lib_dir = '/home/irsyad/bakery_project/bakery_app/lib'
for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r') as f:
                content = f.read()
            
            if '\\$' in content:
                # Add import if needed
                if "import 'package:intl/intl.dart';" not in content:
                    content = "import 'package:intl/intl.dart';\n" + content
                
                # Replace \$${...toStringAsFixed(2)} with Rp format
                # e.g. \$${product.price.toStringAsFixed(2)} -> Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.price)}
                # Regex to match \$${ <var>.toStringAsFixed(2) }
                pattern = r'\\\$(\$\{?[a-zA-Z0-9_\.\(\)\s\*]+\}?)(\.toStringAsFixed\(\d\))?'
                
                def replacer(match):
                    expr = match.group(1)
                    if expr.startswith('${'):
                        inner = expr[2:-1]
                        # if it already has toStringAsFixed inside, remove it
                        inner = re.sub(r'\.toStringAsFixed\(\d\)', '', inner)
                    else:
                        inner = expr[1:]
                        inner = re.sub(r'\.toStringAsFixed\(\d\)', '', inner)
                    
                    return f"Rp ${{NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format({inner})}}"
                
                new_content = re.sub(pattern, replacer, content)
                
                # Also handle \$${total.toStringAsFixed(2)} type strings
                # The pattern above handles most.
                
                with open(path, 'w') as f:
                    f.write(new_content)
