# 📘 Rails Blog App (MySQL)

A simple blog application built with **Ruby on Rails** and **MySQL** as the database. The app allows users to register, log in, and create, update, or delete blog posts. All visitors (including non-logged-in users) can view blogs, but only registered users can manage blogs (CRUD).

---

## ✨ Features

- ✅ User authentication with **Devise** (Register / Login / Logout)
- ✅ Blog **Create**, **Read**, **Update**, and **Delete** operations (CRUD)
- ✅ Blogs can include **image uploads** via **Active Storage**
- ✅ Public blog visibility (viewable without login)
- ✅ Only logged-in users can **create, edit, or delete** their own blogs
- ✅ Responsive UI with basic custom CSS styling

---

## 📁 Project Structure Overview

app/
 ├── controllers/
 │     └── blogs_controller.rb
 ├── models/
 │     └── blog.rb
 │     └── user.rb
 ├── views/
 │     └── blogs/
 │           ├── index.html.erb
 │           ├── show.html.erb
 │           ├── new.html.erb
 │           └── _form.html.erb
 │     └── devise/
 └── assets/stylesheets/
       └── application.css

---

## 🛠 Tech Stack

- **Backend**: Ruby on Rails
- **Frontend**: Embedded Ruby (ERB), HTML/CSS
- **Authentication**: Devise
- **Database**: MySQL
- **Image Uploads**: Active Storage

---

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/rails-blog-app.git
cd rails-blog-app
