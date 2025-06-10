// Service Utilisateurs
Table users {
  id uuid [pk]
  email varchar [unique, not null]
  password_hash varchar [not null]
  first_name varchar
  last_name varchar
  phone varchar
  is_active boolean [default: true]
  created_at timestamp
  updated_at timestamp
}

Table addresses {
  id uuid [pk]
  user_id uuid [ref: > users.id]
  street varchar
  city varchar
  zip_code varchar
  country varchar
  address_type enum('livraison', 'facturation')
}

Table carts {
  id uuid [pk]
  user_id uuid [ref: > users.id]
  created_at timestamp
  updated_at timestamp
}

Table cart_items {
  id uuid [pk]
  cart_id uuid [ref: > carts.id]
  product_id uuid
  quantity int [not null]
}

// Service Produits
Table products {
  id uuid [pk]
  name varchar [not null]
  description text
  price decimal(10,2)
  sku varchar [unique]
  category_id uuid [ref: > categories.id]
  stock int
  created_at timestamp
  updated_at timestamp
}

Table categories {
  id uuid [pk]
  name varchar [not null]
  parent_id uuid [ref: > categories.id, null]
}

Table product_images {
  id uuid [pk]
  product_id uuid [ref: > products.id]
  url varchar
  is_main boolean [default: false]
}

// Service Commandes
Table orders {
  id uuid [pk]
  user_id uuid [ref: > users.id]
  status enum('créée', 'validée', 'expédiée', 'annulée') [default: 'créée']
  total_amount decimal(10,2)
  shipping_address json
  created_at timestamp
}

Table order_items {
  id uuid [pk]
  order_id uuid [ref: > orders.id]
  product_id uuid [ref: > products.id]
  quantity int
  unit_price decimal(10,2)
}

// Service Paiements (Stripe)
Table payments {
  id uuid [pk]
  order_id uuid [ref: > orders.id]
  amount decimal(10,2)
  currency varchar [default: 'EUR']
  method enum('stripe') [default: 'stripe']
  status enum('en_attente', 'réussi', 'échoué', 'remboursé')
  transaction_id varchar
  created_at timestamp
}

// Camunda Orchestration
Table process_instances {
  id uuid [pk]
  process_key varchar
  business_key uuid
  status enum('actif', 'terminé', 'erreur')
}

Table tasks {
  id uuid [pk]
  process_instance_id uuid [ref: > process_instances.id]
  task_name varchar
  status enum('en_attente', 'terminé', 'erreur')
  created_at timestamp
}
