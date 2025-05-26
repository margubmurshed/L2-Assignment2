What is PostgreSQL?
PostgreSQL হলো একটি ওপেনসোর্স রিলেশোনাল ডেটাবেজ ম্যানেজমেন্ট সিস্টেম। এটি SQL (Structured Query Language), ট্রান্স্যাকশন্স, প্রসিডিওরস, JSON ডেটা, রেফারেনশিয়াল ইন্টিগ্রিটি, কাস্টম ফাংশন, কাস্টম টাইপসহ আরো শক্তিশালী ফিচারসগুলো সাপোর্ট করে। এছাড়া এই RDBMS টি অনেক আগে প্রকাশিত হওয়ায় এর কমিউনিটিও অনেক বড় যা এর বিশ্বস্ততা প্রমাণ দেয়। বড় বড় ব্যবসায়িক প্রতিষ্ঠান, ব্যাংকিং, শিক্ষা ও ওয়েব এপ্লিকেশনে পোস্টগ্রেস সফলভাবে ব্যবহৃত হচ্ছে।

What is the purpose of a database schema in PostgreSQL?
PostgreSQL এ স্কিমা হলো একটি ফোল্ডারের মতো যেখানে একই ধরণের জিনিস যেমন- tables, views, functions গুলোকে গ্রুপ আকারে অর্গানাইজ করে করে রাখতে পারি। স্কিমার ভিতর বিভিন্ন ধরনের ডেটাবেজ অবজেক্টস থাকে। 

আমরা স্কিমা কেন ব্যবহার করি?
১। ডেটা অর্গানাইজ করার জন্য
উদাহরণ:
custom schema ছাড়া------

-- hr
create table employees();
create table payroll();

-- sales
create table customers();
create table orders();

এখানে টেবিলগুলো পাবলিক স্কিমার আন্ডারে আছে। যখন ডাটাবেজে অনেকগুলো টেবিল থাকবে তখন ম্যানেজ করা অনেক কষ্টকর হয়ে উঠবে। কারন HR এর আন্ডারে কোন কোন টেবিলগুলো আছে এবং Sales এর আন্ডারে কোন কোন টেবিলগুলো আছে সেগুলো খুজতে অনেক বেগ পেতে হবে।

Custom Schema ব্যবহার করেঃ

create schema hr;
create schema sales;

-- hr
create table hr.employees();
create table hr.payroll();

-- sales
create table sales.customers();
create table sales.orders();

স্কিমা ব্যবহারের ফলে টেবিলগুলো অর্গানাইজ হয়ে থাকে এবং খুজে পেতে সুবিধা হয়।

২। Name conflict হয় না

উদাহরণঃ
custom schema ছাড়া------

-- hr
create table employees();
create table payroll();
create table contacts();

-- sales
create table customers();
create table orders();
create table contacts();

এখানে, একই পাবলিক স্কিমার ভিতর দুটো contacts টেবিল আছে। ফলে কোন টেবিল কার জন্য সেটা বুঝা যায় না এবং একই সাথে একই স্কিমাতে একই নামের দুটো টেবিল ক্রিয়েট করা যায় না।

Custom Schema ব্যবহার করেঃ

create schema hr;
create schema sales;

-- hr
create table hr.employees();
create table hr.payroll();
create table hr.contacts();

-- sales
create table sales.customers();
create table sales.orders();
create table sales.contacts();

স্কিমা ব্যবহারের ফলে টেবিলগুলোর মধ্যে Name conflict দূর হয় এবং মডিউলার থাকে। ফলে দুটি ভিন্ন স্কিমাতে একই নামের টেবিল ব্যবহার করা যায়।

৩। একসেস কন্টোল করা যায়
উদাহরণঃ
grant usage on schema hr to hr_role;
grant select, insert, update, delete on all tables in schema hr to hr_role;

grant usage on schema sales to sales_role;
grant select, insert, update on all tables in schema sales to sales_role;

এখানে, স্কিমা ইউজ করে আমরা নির্দিষ্ট করে দিতে পারছি যে কে কোন টেবিলগুলো ইউজ করতে পারবে এবং কি কি করতে পারবে। যেমন, hr_role সম্বলিত ইউজারগুলো শুধু hr স্কিমার টেবিলগুলো একসেস এবং তার উপর শুধু select, insert, update and delete করতে পারবে। একইভাবে, sales_role সম্বলিত ইউজারগুলো শুধু sales স্কিমার টেবিলগুলো একসেস এবং তার উপর শুধু select, insert, update করতে পারবে, কিন্তু ডিলিট করতে পারবেনা কোনো row।



Explain the Primary Key and Foreign Key concepts in PostgreSQL.
What is the difference between the VARCHAR and CHAR data types?
Explain the purpose of the WHERE clause in a SELECT statement.
What are the LIMIT and OFFSET clauses used for?
How can you modify data using UPDATE statements?
What is the significance of the JOIN operation, and how does it work in PostgreSQL?
Explain the GROUP BY clause and its role in aggregation operations.
How can you calculate aggregate functions like COUNT(), SUM(), and AVG() in PostgreSQL?