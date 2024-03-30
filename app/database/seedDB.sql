DROP TABLE IF EXISTS class, learning_mode, subject, chapter, sub_chapter,material, material_category;


CREATE TABLE user(
    id SERIAL,
    username VARCHAR(25) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE learning_mode(
    id SERIAL,
    name VARCHAR(100) UNIQUE NOT NULL,
    PRIMARY KEY(id)
  );

CREATE TABLE class(
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    learning_mode_id BIGINT unsigned not NULL,
    user_id BIGINT unsigned not NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_learning_mode_class Foreign Key (learning_mode_id) REFERENCES learning_mode(id),
    CONSTRAINT fk_user_class Foreign Key (user_id) REFERENCES user(id)
);


CREATE TABLE subject(
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    thumbnail VARCHAR(255),
    class_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT fk_class_subject Foreign Key (class_id) REFERENCES class(id)
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
INSERT INTO learning_mode(name)
VALUES ('Pembelajaran Thematic'),
       ('Kurikulum Merdeka'),
       ('Pembelajaran Menurut Topik');


insert into user(username,password,email)
values ('yusuf', 'sdasd', 'yusufgmail.com');


CREATE TRIGGER material_name BEFORE INSERT ON material
        FOR EACH ROW
        SET NEW.name =  CONCAT((SELECT name FROM sub_chapter where id = new.sub_chapter_id),' ',(SELECT COUNT(*) FROM material where id = new.id));


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

delimiter |
CREATE TRIGGER init_user_class AFTER INSERT ON user
        FOR EACH ROW
       BEGIN
        INSERT INTO class(name,learning_mode_id,user_id)
		values ('kelas 1',1,new.id),
		('kelas 1',2,new.id),
		('kelas 2',2,new.id),
		('kelas 1',3,new.id),
		('kelas 2',3,new.id),
		('kelas 3',2,new.id),
		('kelas 3',3,new.id),
		('kelas 4',2,new.id),
		('kelas 4',3,new.id),
		('kelas 5',2,new.id),
		('kelas 5',3,new.id),
		('kelas 6',2,new.id),
		('kelas 6',3,new.id),
		('kelas 7',2,new.id),
		('kelas 7',3,new.id),
		('kelas 8',2,new.id),
		('kelas 8',3,new.id),
		('kelas 9',2,new.id),
		('kelas 9',3,new.id),
		('kelas 10',2,new.id),
		('kelas 10',3,new.id),
		('kelas 11',2,new.id),
		('kelas 11',3,new.id),
		('kelas 12',2,new.id),
		('kelas 12',3,new.id),
		('kelas 10 SMK',2,new.id),
		('kelas 10 SMK',3,new.id),
		('kelas 11 SMK',2,new.id),
		('kelas 11 SMK',3,new.id),
		('kelas 12 SMK',2,new.id),
		('kelas 12 SMK',3,new.id);
        end;
        |
delimiter ;

delimiter |
CREATE TRIGGER init_class_subject AFTER INSERT ON class
        FOR EACH ROW
       BEGIN
        INSERT INTO subject(name,thumbnail,class_id)
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

