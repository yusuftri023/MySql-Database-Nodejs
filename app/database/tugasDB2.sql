DROP TABLE IF EXISTS user,class, learning_mode, subject, chapter, sub_chapter,material, material_category;


CREATE TABLE user(
    id SERIAL,
    username VARCHAR(25) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY(id)
);


CREATE TABLE class(
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    user_id BIGINT unsigned not NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_user_class Foreign Key (user_id) REFERENCES user(id)
);

CREATE TABLE learning_mode(
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    class_id BIGINT unsigned not null,
    PRIMARY KEY(id),
    CONSTRAINT fk_class_learning_mode Foreign Key (class_id) REFERENCES class(id)
  );
CREATE TABLE subject(
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    thumbnail VARCHAR(255),
    learning_mode_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_learning_mode_subject Foreign Key (learning_mode_id) REFERENCES learning_mode(id)
);

CREATE TABLE chapter(
    id SERIAL,
    name VARCHAR(100)  NOT NULL,
    thumbnail VARCHAR(255),
    progress DECIMAL(5,2) NOT NULL DEFAULT 0,
    subject_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_subject_chapter Foreign Key (subject_id) REFERENCES subject(id)
);

CREATE TABLE sub_chapter(
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    thumbnail VARCHAR(255),
    progress DECIMAL(5,2) NOT NULL DEFAULT 0,
    is_free BOOLEAN NOT NULL DEFAULT FALSE,
    chapter_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_sub_chapter Foreign Key (chapter_id) REFERENCES chapter(id)
);
CREATE TABLE material_category(
    id SERIAL,
    name VARCHAR(20) UNIQUE NOT NULL,
    exp INT,
    gold INT,
    PRIMARY KEY(id)
);
CREATE TABLE material(
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    thumbnail VARCHAR(255),
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    sub_chapter_id BIGINT UNSIGNED NOT NULL,
    material_category_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_sub_chapter_material Foreign Key (sub_chapter_id) REFERENCES sub_chapter(id),
    CONSTRAINT fk_material_category Foreign Key (material_category_id) REFERENCES material_category(id)
);


INSERT INTO material_category(name,exp, gold)
VALUES ('Single quiz',50,50),
       ('Video',150,50),
       ('End quiz',NULL,NULL),
       ('Summary',NULL,NULL);


insert into user(username,password,email)
values ('yusuf', 'sdasd', 'yusufgmail.com');


CREATE TRIGGER material_name BEFORE INSERT ON material
        FOR EACH ROW
        SET NEW.name =  CONCAT((SELECT name FROM sub_chapter where id = new.sub_chapter_id),' ',(SELECT COUNT(*) FROM material where id = new.id));




delimiter |
CREATE TRIGGER init_user_class AFTER INSERT ON user
        FOR EACH ROW
       BEGIN
        INSERT INTO class(name,user_id)
		values ('kelas 1',new.id),
		('kelas 2',new.id),
		('kelas 3',new.id),
		('kelas 4',new.id),
		('kelas 5',new.id),
		('kelas 6',new.id),
		('kelas 7',new.id),
		('kelas 8',new.id),
		('kelas 9',new.id),
		('kelas 10',new.id),
		('kelas 11',new.id),
		('kelas 12',new.id),
		('kelas 10 SMK',new.id),
		('kelas 11 SMK',new.id),
		('kelas 12 SMK',new.id);
        end;
        |
delimiter ;

delimiter |
CREATE TRIGGER init_class_learning_mode AFTER INSERT ON class
        FOR EACH ROW
       BEGIN
        INSERT INTO learning_mode(name,class_id)
        VALUES ('Pembelajaran Thematic',new.id),
               ('Kurikulum Merdeka',new.id),
               ('Pembelajaran Menurut Topik',new.id);
        end;
        |
delimiter ;

delimiter |
CREATE TRIGGER init_learning_mode_subject AFTER INSERT ON learning_mode
        FOR EACH ROW
       BEGIN
        INSERT INTO subject(name,thumbnail,learning_mode_id)
        VALUES ('IPA','https://i.imgur.com/LDOO4Qs.jpeg' , new.id),
               ('Bahasa Inggris','https://i.imgur.com/LDOO4Qs.jpeg' ,new.id),
               ('Bahasa Indonesia','https://i.imgur.com/LDOO4Qs.jpeg' ,new.id),
               ('Matematika','https://i.imgur.com/LDOO4Qs.jpeg' ,new.id);
        end;
        |
delimiter ;

delimiter |
CREATE TRIGGER init_subject_chapter AFTER INSERT ON subject
        FOR EACH ROW
       BEGIN
        INSERT INTO chapter(name,thumbnail, subject_id)
		VALUES ('Bilangan 0-10','https://i.imgur.com/LDOO4Qs.jpeg',new.id),
		       ('Aplikasi Bilangan 0-10','https://i.imgur.com/LDOO4Qs.jpeg',new.id),
		       ('Bilangan 11-20','https://i.imgur.com/LDOO4Qs.jpeg' ,new.id),
		       ('Geometri dan pola','https://i.imgur.com/LDOO4Qs.jpeg',new.id);
        end;
        |
delimiter ;

delimiter |
CREATE TRIGGER init_chapter_sub AFTER INSERT ON chapter
        FOR EACH ROW
       BEGIN
        INSERT INTO sub_chapter(name,thumbnail,is_free,chapter_id)
		VALUES ('Mengenal bilangan 1-10 (1)','https://i.imgur.com/LDOO4Qs.jpeg',TRUE,new.id),
		       ('Mengenal bilangan 1-10 (2)','https://i.imgur.com/LDOO4Qs.jpeg',FALSE,new.id),
		       ('Lebih besar? Lebih kecil? 1-10','https://i.imgur.com/LDOO4Qs.jpeg',TRUE,new.id),
		       ('Bermain dengan bilangan 1-10','https://i.imgur.com/LDOO4Qs.jpeg',TRUE,new.id);
        end;
        |
delimiter ;

delimiter |
CREATE TRIGGER init_sub_chapter_material AFTER INSERT ON sub_chapter
        FOR EACH ROW
       BEGIN
        INSERT INTO material(thumbnail,sub_chapter_id,material_category_id)
		VALUES ('https://i.imgur.com/LDOO4Qs.jpeg',new.id,3),
		       ('https://i.imgur.com/LDOO4Qs.jpeg',new.id,4),
		       ('https://i.imgur.com/LDOO4Qs.jpeg',new.id,1),
		       ('https://i.imgur.com/LDOO4Qs.jpeg',new.id,1),
		       ('https://i.imgur.com/LDOO4Qs.jpeg',new.id,2),
		       ('https://i.imgur.com/LDOO4Qs.jpeg',new.id,2);
        end;
        |
delimiter ;



delimiter |
CREATE TRIGGER update_sub_chapter_progress AFTER UPDATE ON material
        FOR EACH ROW
       BEGIN
        IF NEW.is_completed != OLD.is_completed THEN
            UPDATE sub_chapter
            set progress = (select count(*) from material where sub_chapter_id = OLD.sub_chapter_id AND is_completed =  TRUE)/(select count(*) from material where sub_chapter_id = OLD.sub_chapter_id)*100
            where id = OLD.sub_chapter_id;
            end if;
        end;
        |
delimiter ;

delimiter |
CREATE TRIGGER update_chapter_progress AFTER UPDATE ON sub_chapter
        FOR EACH ROW
       BEGIN
        IF NEW.progress = 100 THEN
            UPDATE chapter
            set progress = (select count(*) from sub_chapter where chapter_id = OLD.chapter_id AND progress =  100)/(select count(*) from sub_chapter where chapter_id = OLD.chapter_id)*100
            where id = OLD.chapter_id;
            end if;
        end;
        |
delimiter ;


-- query plan

-- Front page

-- insert new user
INSERT INTO user(username, email, password)
      VALUES (?,?,?)
-- check user if exist
SELECT * FROM user where username = ? or email = ?
-- user overall progress (exp dan gold)
select sum(mc.exp) userTotalExp, sum(mc.gold) userTotalGold  from material m
    inner join material_category mc
    on m.material_category_id =mc.id
    inner join sub_chapter sc
    on m.sub_chapter_id =sc.id
    inner join chapter c
    on sc.chapter_id = c.id
    inner join subject s
    on c.subject_id = s.id
    inner join learning_mode lm
    on s.learning_mode_id =lm.id
    inner join class c2
    on lm.class_id = c2.id
    inner join user u
    on c2.user_id = u.id
    where u.id = ? and m.is_completed is true;
-- user info
SELECT * FROM user where user.id = ?

-- list kelas yang ada di user
SELECT u.username , c.* FROM user u
    LEFT JOIN class c
    ON u.id = c.user_id
    where u.id = ?;

-- list mode pembelajaran yang ada pada kelas yang dipilih
SELECT c.id class_id, c.name class_name,lm.id learning_mode_id, lm.name learning_mode_name FROM class c
    LEFT JOIN learning_mode lm
    ON c.id  = lm.class_id
    WHERE c.id = ?;


-- list subject/mata pelajaran yang tersedia
SELECT * FROM learning_mode lm
    LEFT JOIN subject s
    ON lm.id = s.learning_mode_id
    WHERE s.learning_mode_id = ?;

-- list semua chapter yang tersedia lengkap dengan progress
SELECT * FROM subject s
    LEFT JOIN chapter c
    ON s.id = c.subject_id
    WHERE c.subject_id = ?;

-- halaman list bab/chapter jumlah sub bab/ sub_chapter yang gratis
select chapter_id ,chapter_name, chapter_progress,count(sub_chapter_id) as free_sub_chapter_number from
    (SELECT s.id subject_id , s.name  as subject_name, c.id chapter_id, c.name as chapter_name,c.thumbnail,c.progress as chapter_progress, sc.id as sub_chapter_id,sc.name as sub_chapter_name,sc.is_free FROM subject s
    LEFT JOIN chapter c
    ON s.id = c.subject_id
    LEFT JOIN sub_chapter sc
    ON c.id = sc.chapter_id
    WHERE s.id = ? and is_free is true) as subject_content
    group by chapter_id;

-- list semua sub chapter yang tersedia lengkap dengan progress
select c.id as chapter_id, sc.id as sub_chapter_id, sc.thumbnail, sc.progress, sc.is_free FROM chapter c
LEFT JOIN sub_chapter sc
ON c.id = sc.chapter_id
WHERE c.id = 169;

-- list semua material yang tersedia lengkap dengan status pengerjaan, category, exp dan gold
SELECT m.id, m.name,m.thumbnail,m.is_completed, mc.name as category, mc.exp, mc.gold FROM sub_chapter sc
LEFT JOIN material m
on sc.id = m.sub_chapter_id
INNER JOIN material_category mc
on m.material_category_id = mc.id
where sc.id = 661;

