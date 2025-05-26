## 1. What is PostgreSQL?
**PostgreSQL** হলো একটি ওপেনসোর্স রিলেশোনাল ডেটাবেজ ম্যানেজমেন্ট সিস্টেম। এটি SQL (Structured Query Language), ট্রান্স্যাকশন্স, প্রসিডিওরস, JSON ডেটা, রেফারেনশিয়াল ইন্টিগ্রিটি, কাস্টম ফাংশন, কাস্টম টাইপসহ আরো শক্তিশালী ফিচারসগুলো সাপোর্ট করে। এছাড়া এই RDBMS টি অনেক আগে প্রকাশিত হওয়ায় এর কমিউনিটিও অনেক বড় যা এর বিশ্বস্ততা প্রমাণ দেয়। বড় বড় ব্যবসায়িক প্রতিষ্ঠান, ব্যাংকিং, শিক্ষা ও ওয়েব এপ্লিকেশনে পোস্টগ্রেস সফলভাবে ব্যবহৃত হচ্ছে।

## 2. What is the purpose of a database schema in PostgreSQL?
**PostgreSQL এ স্কিমা** হলো একটি ফোল্ডারের মতো যেখানে একই ধরণের জিনিস যেমন- tables, views, functions গুলোকে গ্রুপ আকারে অর্গানাইজ করে করে রাখতে পারি। স্কিমার ভিতর বিভিন্ন ধরনের ডেটাবেজ অবজেক্টস থাকে। 

### আমরা স্কিমা কেন ব্যবহার করি?

#### ১। ডেটা অর্গানাইজ করার জন্য
উদাহরণ:
custom schema ছাড়া------

```sql
-- hr
create table employees();
create table payroll();

-- sales
create table customers();
create table orders();
```

এখানে টেবিলগুলো পাবলিক স্কিমার আন্ডারে আছে। যখন ডাটাবেজে অনেকগুলো টেবিল থাকবে তখন ম্যানেজ করা অনেক কষ্টকর হয়ে উঠবে। কারন HR এর আন্ডারে কোন কোন টেবিলগুলো আছে এবং Sales এর আন্ডারে কোন কোন টেবিলগুলো আছে সেগুলো খুজতে অনেক বেগ পেতে হবে।

Custom Schema ব্যবহার করেঃ

```sql
create schema hr;
create schema sales;

-- hr
create table hr.employees();
create table hr.payroll();

-- sales
create table sales.customers();
create table sales.orders();
```

স্কিমা ব্যবহারের ফলে টেবিলগুলো অর্গানাইজ হয়ে থাকে এবং খুজে পেতে সুবিধা হয়।

#### ২। Name conflict হয় না

উদাহরণঃ
custom schema ছাড়া------

```sql
-- hr
create table employees();
create table payroll();
create table contacts();

-- sales
create table customers();
create table orders();
create table contacts();
```

এখানে, একই পাবলিক স্কিমার ভিতর দুটো contacts টেবিল আছে। ফলে কোন টেবিল কার জন্য সেটা বুঝা যায় না এবং একই সাথে একই স্কিমাতে একই নামের দুটো টেবিল ক্রিয়েট করা যায় না।

Custom Schema ব্যবহার করেঃ

```sql
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
```

স্কিমা ব্যবহারের ফলে টেবিলগুলোর মধ্যে Name conflict দূর হয় এবং মডিউলার থাকে। ফলে দুটি ভিন্ন স্কিমাতে একই নামের টেবিল ব্যবহার করা যায়।

#### ৩। একসেস কন্টোল করা যায়
উদাহরণঃ
```sql
grant usage on schema hr to hr_role;
grant select, insert, update, delete on all tables in schema hr to hr_role;

grant usage on schema sales to sales_role;
grant select, insert, update on all tables in schema sales to sales_role;
```

এখানে, স্কিমা ইউজ করে আমরা নির্দিষ্ট করে দিতে পারছি যে কে কোন টেবিলগুলো ইউজ করতে পারবে এবং কি কি করতে পারবে। যেমন, hr_role সম্বলিত ইউজারগুলো শুধু hr স্কিমার টেবিলগুলো একসেস এবং তার উপর শুধু select, insert, update and delete করতে পারবে। একইভাবে, sales_role সম্বলিত ইউজারগুলো শুধু sales স্কিমার টেবিলগুলো একসেস এবং তার উপর শুধু select, insert, update করতে পারবে, কিন্তু ডিলিট করতে পারবেনা কোনো row।



## 3. Explain the Primary Key and Foreign Key concepts in PostgreSQL.
### Primary Key
একটি টেবিলের প্রাইমারি কি হলো একটি টেবিলের এক বা একাধিক কলামের সমষ্টি যা ঐ টেবিলের row গুলোকে অনন্যভাবে সনাক্ত করে। প্রাইমারি কি কখনো null হতে পারবে না এবং ডুপ্লিকেট হতে পারবে না।

### Foreign Key
একটি টেবিলের একটি ফরেন কি হলো একটি কলাম যা অন্য টেবিলের প্রাইমারি কি। এটি একটি টেবিলের সাথে আরেকটি টেবিলের ভিতর সম্পর্ক তৈরি করতে ব্যবহৃত হয় এবং রেফারেনশিয়াল ইন্টিগ্রিটি তৈরি করে। ফলে এক টেবিলের ডেটা আরেক টেবিলের ডেটার সাথে যুক্ত এবং বৈধ থাকে।

উদাহরণঃ
```sql
create table rangers(
    ranger_id serial primary key,
    name text
)

create table sightings(
    sighting_id serial primary key,
    ranger_id integer references rangers(ranger_id)
)
```
এখানে, sightings.ranger_id হলো একটি ফরেন কি যেটি rangers.ranger_id কে রেফার করছে। ফলে sightings এ থাকা কোন রেঞ্জারকে আমরা সরাসরি রেঞ্জার থেকে ডিলিট করতে পারবোনা এবং sightings এ কোনো নতুন রেঞ্জারকে rangers এ এড না করে insert করতে পারবোনা। যার ফলে দুটো টেবিলের মধ্যে রেফারেন্সিয়াল ইন্টিগ্রিটি তৈরি হয়েছে।

## 4. What is the difference between the VARCHAR and CHAR data types?
VARCHAR এবং CHAR দুইটাই string data সংরক্ষণ করতে ব্যবহৃত হয়। কিন্তু এদের ভিতর পার্থক্য রয়েছে।
### VARCHAR(n) এর বৈশিষ্ট্য
- এটি n সংখ্যক বা তার কম দৈর্ঘ্যের string সংরক্ষণ করে।
- string যতটুকু ততটুকুই জায়গা নেয়।
- অনির্দিষ্ট দৈর্ঘ্যের string এর জন্য সুবিধাজনক।

### CHAR(n) এর বৈশিষ্ট্য
- এটি n সংখ্যক দৈর্ঘ্যের string সংরক্ষণ করে।
- string টি n এর চেয়ে ছোট হলেও, n সংখ্যক দৈর্ঘ্যেরই জায়গা নেয়।
- নির্দিষ্ট দৈর্ঘ্যের string এর জন্য সুবিধাজনক

উদাহরণঃ
```sql
name VARCHAR(50), -- 'Liakat Ali', বাড়তি স্পেস এড করা হয়নি কোনো
code CHAR(4) -- 'ABCD', বাড়তি স্পেস এড হবে যদি ৪ এর চেয়ে কম দেয়া হয় => 'AB  ' 
```

## 5. Explain the purpose of the WHERE clause in a SELECT statement.
SELECT এ WHERE clause ব্যবহার করা হয় একটি টেবিলের রেকোর্ডগুলা থেকে নির্দিষ্ট কন্ডিশনের ভিত্তিতে নির্দিষ্ট রেকোর্ডগুলো বের করে আনার জন্য। ফলে আমরা সবগুলো রেকোর্ড সিলেক্ট না করে যেগুলো আমাদের প্রয়োজন সেই রেকোর্ড করে বের করে আনতে পারি এবং সেগুলো নিয়ে কাজ করতে পারি।

উদাহরণঃ
```sql
SELECT * from species
WHERE extract(year from discovery_date) < 1800;
```
উপরের কুয়েরিটি সেই স্পেশিসগুলো দিচ্ছে যেগুলো ১৮০০ সালের আগে খুজে পাওয়া গিয়েছে। এখানে, WHERE এর পরে (extract(year from discovery_date) < 1800) এক্সপ্রেশনটি হলো কন্ডিশন।

WHERE গুরুত্বপূর্ণ কারন -
- কন্ডিশনের উপর ভিত্তি করে প্রয়োজনীয় রেকোর্ডগুলো খুঁজে বের করে দেয় ফলে পার্ফর্মেন্স বৃদ্ধি পায়।
- অপ্রয়োজনীয় রেকোর্ডগুলোকে অপসারণ করে।
- ডেটা এনালাইসিস এবং রিপোর্টিং এ গুরুত্বপূর্ণ ভূমিকা রয়েছে।