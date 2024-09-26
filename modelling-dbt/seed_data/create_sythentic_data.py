# Importing necessary libraries
import os
import pandas as pd
import random
from faker import Faker

# Initialize Faker instance
fake = Faker()

# Creating function for the random selection in the synthetic data
def random_gender():
    return random.choice(['Male', 'Female'])

def random_item_category():
    return random.choice(['Appetizer', 'Main Course', 'Dessert', 'Beverage'])


payment_methods = {
    'pay_id':[1, 2, 3],
    'payment_method':['Cash', 'Debit Card', 'Online Payment']
}

dining_options = {
    'do_id':[1, 2, 3],
    'option': ['Dine-in', 'Dine-out', 'Online']
}

nigerian_foods = {
    'Jollof Rice': 'A popular West African dish made with rice, tomatoes, onions, and a blend of spices.',
    'Pounded Yam': 'A smooth dough-like food made from boiled yams, often eaten with a variety of soups.',
    'Egusi Soup': 'A thick, hearty soup made from ground melon seeds, spinach, and meat or fish.',
    'Moi Moi': 'A steamed bean pudding made from peeled beans, onions, and peppers.',
    'Suya': 'Spicy skewered beef or chicken, often served with onions and tomatoes.',
    'Amala': 'A Nigerian food made from yam flour, commonly served with ewedu or gbegiri soup.',
    'Akara': 'Deep-fried fritters made from ground beans and spices, often served as a snack.',
    'Pepper Soup': 'A spicy soup made with a variety of meats, fish, and hot pepper spices.',
    'Fried Plantain': 'Fried ripe plantains, a sweet and savory dish often served as a side.',
    'Ofada Rice': 'Locally grown Nigerian rice, served with a peppery sauce and assorted meats.'
}

menu_names = [
        'Taste of Naija',
        'Spice and Flavor',
        'Naija Delights',
        'Flavors of Lagos'
        ]

# Data for the branch locations
branches_data = {
    'branch_id': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    'branch_name': [
        'Lagos Central', 'Abuja Main', 'Kano North', 'Port Harcourt Central', 
        'Enugu South', 'Ibadan West', 'Kaduna North', 'Benin City Central', 
        'Owerri East', 'Uyo Main'
    ],
    'location': [
        'Lagos', 'Abuja', 'Kano', 'Port Harcourt', 'Enugu', 
        'Ibadan', 'Kaduna', 'Benin City', 'Owerri', 'Uyo'
    ],
    'address': [
        '123 Victoria Island, Lagos', '45 Garki Area, Abuja', '89 Zaria Road, Kano', 
        '67 Trans Amadi, Port Harcourt', '12 Chime Avenue, Enugu', 
        '43 Ring Road, Ibadan', '21 Ahmadu Bello Way, Kaduna', 
        '34 Airport Road, Benin City', '15 Wetheral Road, Owerri', 
        '78 Oron Road, Uyo'
    ]
}

# Generate synthetic staff data
def generate_staff(num_records):
    staff_records = []
    for i in range(num_records):
        staff = {
            'staff_id': i+1,
            'first_name': fake.first_name(),
            'last_name': fake.last_name(),
        }
        # Assign branch_id for the first 10 staff (1 to 10)
        if i < 10:
            staff['branch_id'] = i + 1  # Ensures branch_id is 1 to 10
            staff['manager_id'] = None  # No manager for the first 10
        else:
            staff['branch_id'] = fake.random_int(min=1, max=10)  # Random branch_id for staff after the first 10
            staff['manager_id'] = fake.random_int(min=1, max=10)  # Random manager_id from 0 to 9 (or 1 to 10 if preferred)
        
        staff_records.append(staff)
    return pd.DataFrame(staff_records)

# Generate synthetic customer data
def generate_customers(num_records):
    customers = []
    for i in range(num_records):
        customer = {
            'customer_id': i+1,
            'first_name': fake.first_name(),
            'last_name': fake.last_name(),
            'gender': random_gender(),
            'age': fake.random_int(min=15, max=75),
            'email': fake.email(),
            'phone_number': fake.phone_number(),
        }
        customers.append(customer)
    return pd.DataFrame(customers)

def generate_products(num_products, num_menus=4):
    products = []
    food_items = list(nigerian_foods.items())  # List of tuples (product_name, description)
    for i in range(num_products):
        product_name, description = random.choice(food_items)
        product = {
            'product_id': i + 1,
            'product_name': product_name,
            'description': description,
            'price': round(random.uniform(500, 3000), 2),  # Random price between 500 and 3000
            'menu_id': random.randint(1, num_menus)  # Randomly assign to one of the 4 menus
        }
        products.append(product)
    return pd.DataFrame(products)

def generate_menus():
    menus = []
    for i in range(len(menu_names)):
        menu = {
            'menu_id': i + 1,
            'menu_name': menu_names[i],
            'branch_id': random.randint(1, 10),  # Assuming 10 branches
            'is_active': fake.boolean(chance_of_getting_true=80)  # 80% chance the menu is active
        }
        menus.append(menu)
    return pd.DataFrame(menus)

# Generate synthetic sales data
def generate_sales(num_records, customers, branches, products):
    sales = []
    for i in range(num_records):
        sale = {
            'sales_id': fake.uuid4(),
            'customer_id': random.choice(customers['customer_id']),
            'branch_id': random.choice(branches['branch_id']),
            'pay_id': random.choice(payment_methods['pay_id']),
            'do_id': random.choice(dining_options['do_id']),
            'product_id': random.choice(products['product_id']),
            'quantity': random.randint(1, 10),
            'payment_method': random.choice(['Cash', 'Debit Card', 'Online']),
            'dining_option': random.choice(['Dine-in', 'Take-out', 'Online']),
            'rating': round(random.uniform(1.0, 5.0), 1),
            'sales_date': fake.date_this_year(),
        }
        sales.append(sale)
    return pd.DataFrame(sales)

# Generate and save the data
num_records = 1000

df_staff = generate_staff(50)
df_customers = generate_customers(500)
df_branches = pd.DataFrame(branches_data)
#df_payment_method = pd.DataFrame(payment_methods)
#df_dining_options = pd.DataFrame(dining_options)
df_products = generate_products(10)
df_menus = generate_menus()
df_sales = generate_sales(num_records, df_customers, df_branches, df_products)

# Save the data to CSV files
df_staff.to_csv('staff.csv', index=False)
df_customers.to_csv('customers.csv', index=False)
df_branches.to_csv('branches.csv', index=False)
df_products.to_csv('products.csv', index=False)
df_menus.to_csv('menu.csv', index=False)
df_sales.to_csv('transactions.csv', index=False)


print("Synthetic data generated and saved as CSV files!")
