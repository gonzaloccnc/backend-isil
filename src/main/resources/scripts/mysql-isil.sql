DROP DATABASE `isil-lms`;
CREATE DATABASE `isil-lms`;

USE `isil-lms`;

CREATE TABLE careers (
    id_career varchar(36) NOT NULL PRIMARY KEY,
    title varchar(200) NOT NULL,
    description text NOT NULL
);

CREATE TABLE users (
	id_user varchar(36) NOT NULL PRIMARY KEY,
	firstname varchar(100) NOT NULL,
	surnames varchar(100) NOT NULL,
	birthday date,
	address varchar(200),
	doc_id varchar(20) NOT NULL UNIQUE,
	type_doc smallint NOT NULL,
	password varchar(150) NOT NULL,
	email varchar(100) NOT NULL UNIQUE,
	phone varchar(9) UNIQUE,
	register_date date,
	state smallint NOT NULL,
	user_type smallint NOT NULL,
	photo text,
	id_career varchar(36),
    FOREIGN KEY (id_career) REFERENCES careers(id_career)
);

CREATE TABLE courses (
	id_course varchar(36) NOT NULL PRIMARY KEY,
	course_name VARCHAR(150) NOT NULL,
	credits SMALLINT NOT NULL,
	description TEXT NOT NULL,
	syllabus VARCHAR(200) NOT NULL,

    creation_date DATETIME NOT NULL DEFAULT NOW(),
    updated_date DATETIME NULL,
    user_creation VARCHAR(36) NOT NULL,
    user_updating VARCHAR(36) NULL,
    FOREIGN KEY (user_creation) REFERENCES users (id_user),
    FOREIGN KEY (user_updating) REFERENCES users (id_user)
);

CREATE TABLE contents (
	id_content SMALLINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(150) NOT NULL,
	description TEXT NOT NULL,
	link_file VARCHAR(200) NOT NULL,
	num_order SMALLINT NOT NULL,
	id_course varchar(36) NOT NULL,

    creation_date DATETIME NOT NULL DEFAULT NOW(),
    updated_date DATETIME NULL,
    user_creation VARCHAR(36) NOT NULL,
    user_updating VARCHAR(36) NULL,
    FOREIGN KEY (user_creation) REFERENCES users (id_user),
    FOREIGN KEY (user_updating) REFERENCES users (id_user),

    CHECK(num_order BETWEEN 1 AND 16),
    foreign key (id_course) references courses(id_course)
);

CREATE TABLE classrooms (
 id_classroom varchar(36) NOT NULL PRIMARY KEY,
 nrc VARCHAR(4) NOT NULL UNIQUE,
 school_day varchar(9) NOT NULL,
 start_time time NOT NULL,
 end_time time NOT NULL,
 link_meet varchar(250) NOT NULL,
 total_hours smallint NOT NULL,
 modality smallint NOT NULL,
 campus varchar(10) NOT NULL,
 `period` varchar(6) NOT NULL,
 start_date date NOT NULL,
 end_date date NOT NULL,
 max_members INT NOT NULL,
 id_teacher varchar(36) NOT NULL,
 id_course varchar(36) NOT NULL,

 creation_date DATETIME NOT NULL DEFAULT NOW(),
 updated_date DATETIME NULL,
 user_creation VARCHAR(36) NOT NULL,
 user_updating VARCHAR(36) NULL,
 FOREIGN KEY (user_creation) REFERENCES users (id_user),
 FOREIGN KEY (user_updating) REFERENCES users (id_user),

 foreign key (id_teacher) references users(id_user),
 foreign key (id_course) references courses(id_course)
);

CREATE TABLE feeds (
	id_feed varchar(36) NOT NULL PRIMARY KEY,
	title VARCHAR(150) NOT NULL,
	description TEXT NOT NULL,
    date_created datetime not null default now(),
    date_updated datetime null,
	id_classroom varchar(36) null,
    foreign key (id_classroom) references classrooms(id_classroom)
);

CREATE TABLE class_students (
 id_classroom varchar(36) NOT NULL,
 id_student varchar(36) NOT NULL,
 registration_date datetime not null default now(),
 primary key (id_classroom, id_student),
 foreign key (id_classroom) references classrooms(id_classroom),
 foreign key (id_student) references users(id_user)
);

CREATE TABLE records (
	id_record varchar(36) NOT NULL PRIMARY KEY,
	order_num smallint NOT NULL,
	title VARCHAR(200) NOT NULL,
    id_classroom varchar(36) not null,
	foreign key (id_classroom) REFERENCES classrooms(id_classroom)
);

CREATE TABLE complementaries (
	id_complementary varchar(36) not null primary key,
    title varchar(200) not null,
    link_file text,
    upload_date datetime,
    id_classroom varchar(36) not null,
    foreign key (id_classroom) references classrooms(id_classroom)
);

CREATE TABLE groups_class (
    id_group INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    group_name varchar(50)
);

CREATE TABLE class_groups_students (
    id_classroom VARCHAR(36) NOT NULL,
    id_student VARCHAR(36) NOT NULL,
	id_group INT NOT NULL,
    PRIMARY KEY (id_classroom, id_student),
    FOREIGN KEY (id_classroom) REFERENCES classrooms (id_classroom),
    FOREIGN KEY (id_student) REFERENCES users (id_user),
    FOREIGN KEY (id_group)  REFERENCES groups_class(id_group)
);

/* CONTRAINTS */

-- DNI, CARNET EXTRANJERIA
ALTER TABLE users ADD CONSTRAINT ck_typedoc CHECK (type_doc IN(0, 1));
ALTER TABLE users ADD CONSTRAINT ck_type_user CHECK (user_type IN(1, 2, 3));
ALTER TABLE users ADD CONSTRAINT ck_maxlength_doc
	CHECK ( (type_doc = 0 AND (char_length(doc_id) = 8) )
		OR ( type_doc = 1 AND (char_length(doc_id) BETWEEN 8 AND 20) )
);

-- activo, inactivo, egresado, expiro
ALTER TABLE users ADD CONSTRAINT ck_state CHECK (state IN(0, 1, 2, 3));

ALTER TABLE courses ADD CONSTRAINT ck_limit_credits CHECK (credits IN (2, 3, 4));

-- virtual, remoto, semiremoto ,presencial
ALTER TABLE classrooms ADD CONSTRAINT ck_modality_class CHECK (modality IN(1, 2, 3, 4));

/*
-- private, visible
ALTER TABLE class_evaluations ADD CONSTRAINT ck_evaluation_visibility CHECK (visibility IN (0, 1));
*/

/* INSERTS */

INSERT INTO careers (id_career, title, description) VALUES
    ('d0324ce6-ca05-4915-a2fb-9c2fdea6bcb6', 'Diseño de Medios Interactivos (UX)', 'Aprende a diseñar y desarrollar soluciones digitales innovadoras para páginas web y aplicaciones móviles.'),
    ('cced1f4b-0b98-4b0c-b4b9-55b68b9b8189', 'Diseño Gráfico', 'Aprende a desarrollar proyectos visuales de valor, empleando las últimas tendencias y herramientas del mercado.'),
    ('94f43c1c-3281-4b9b-8948-4d5c5a3f411b', 'Diseño de Interiores', 'Aprende a planificar, concebir, dirigir y supervisar la implementación de proyectos integrales de diseño.'),
    ('b37f5ce2-b154-42e0-a9f3-8b12a8465257', 'Animación Digital y Diseño 3D', 'Aprende a diseñar modelos y animaciones tridimensionales de manera digital.'),
    ('6784fb5c-13a2-4e8d-af81-de2f3cc5a2a3', 'Diseño y Desarrollo de Videojuegos', 'Aprende diseñar, desarrollar e implementar juegos y aplicaciones multimedia de alta demanda en el mercado laboral.'),
    ('9ed8fc23-97d9-45ca-b83b-9f685309af77', 'Fotografía y Producción de Imagen', 'Crea, desarrolla y gestiona productos fotográficos periodísticos y publicitarios con énfasis en la producción de moda, food styling, cobertura de eventos, entre otros.'),
    ('656d2636-0f19-4b95-ad7f-f351cbfcaa41', 'Comunicación Audiovisual', 'Aprende a crear, desarrollar y gestionar productos audiovisuales para televisión, web y dispositivos móviles dominando las herramientas digitales y multimedia.'),
    ('8f0381fe-d954-4276-8b71-28863a2dc792', 'Comunicación Integral', 'Aprende a crear y ejecutar planes según las necesidades de tu audiencia, utilizando técnicas multimedia en distintas plataformas de comunicación.'),
    ('90375c33-76f0-4be4-89f2-750906eec124', 'Periodismo Deportivo', 'Aprende a desarrollar proyectos periodísticos deportivos, generando información periodística de manera minuciosa y ética.'),
    ('8194a035-2d9c-4d4a-9611-86aa23a4cc3d', 'Marketing y Gestión de Moda', 'Aprende gestionar grandes marcas de moda para empresas del sector retail y a desarrollar tu propio emprendimiento con una visión global de negocio.'),
    ('a2987e08-60c5-4c1e-9be9-6576874c2fa1', 'Marketing', 'Aprende a captar la atención de tus consumidores, identificando y satisfaciendo una necesidad o incluso generando una nueva.'),
    ('d9c0c53a-2d6a-434d-874a-8d0b6ed8e31d', 'Publicidad y Medios Digitales', 'Aprende a desarrollar campañas publicitarias en medios off y online con un criterio estratégico y creativo.'),
    ('b201efb1-d91c-449a-aafa-9ccbd4311f8f', 'Gestión Comercial y Negocios Digitales', 'Analiza las tendencias y ejecuta planes de desarrollo de una empresa, producto o servicio utilizando herramientas digitales.'),
    ('751f0b1e-7688-4687-a602-2e654889433b', 'Administración de Empresas', 'Aprende a gestionar de forma estratégica las distintas áreas involucradas en un negocio, tales como finanzas, marketing, operaciones, entre otras.'),
    ('e7257980-c03b-4b50-9133-b799baf036b8', 'Negocios Internacionales', 'Aprende a detectar, crear, promover y gestionar los negocios en el contexto de los mercados globales.'),
    ('1baeac28-b877-491a-be30-edf88e604eda', 'Administración y Finanzas', 'Aprende a gestionar las finanzas de una forma estratégica y enfocada en los objetivos de negocio.'),
    ('d0344597-a96f-49c2-8338-6b84c55dd0dd', 'Recursos Humanos', 'Aprende a alinear la estrategia de negocio con la gestión de personas considerando el marco laboral vigente.'),
    ('22e61128-f892-43be-a607-9d3f90c16f51', 'Administración Bancaria', 'Aprende a asesorar con solvencia a clientes financieros y gestionar de forma eficiente las agencias bancarias.'),
    ('6167765f-3c68-4273-a508-53e0ed21d331', 'Gestión Logística Integral', 'Aprende a manejar la logística en organizaciones modernas con especial énfasis en el uso de tecnología digital y siguiendo las tendencias del mercado'),
    ('b4622d94-58ad-4b90-bfd7-e39871297ccc', 'Desarrollo de Software', 'Aprende a diseñar, desarrollar y poner en marcha soluciones informáticas sobre aplicaciones de software nuevas y/o existentes.'),
    ('8479031d-0693-4b3f-9bba-ce0521284d01', 'Redes y Comunicaciones', 'Aprende a analizar, diseñar e implementar soluciones seguras sobre infraestructura tecnológica nueva o existente.'),
    ('104845f4-1120-40a9-9027-484ffbe4f3a1', 'Sistemas de Información', 'Aprende gestionar proyectos, realizar labores de análisis funcional y desarrollar soluciones informáticas sobre tecnología nueva o existente.'),
    ('d4fdf222-bc44-40d0-8b9f-02f9da02ef5e', 'Hotelería', 'Aprende a administrar empresas de hospedaje, así como también de alimentos o bebidas, utilizando los mejores softwares de gestión.'),
    ('12c8dd01-5d2c-4681-aa2d-ae0302999b41', 'Turismo', 'Aprovecha los recursos y atractivos turísticos con los que cuenta el Perú, dentro del contexto general de turismo receptivo.');


INSERT INTO users (id_user, firstname, surnames, birthday, address, type_doc, doc_id, password, email, phone, id_career, register_date, state, photo, user_type)
VALUES
  ('1c995ab5-3e36-4bd5-bf9c-13a866d849d8', 'Gonzalo Pedro', 'Manco Garcia', '2002-10-03', 'Avenida Petit Thoars 5532', 0, '70395407', 'isil20203', 'gonzadevelw@gmail.com', '914792763', 'b4622d94-58ad-4b90-bfd7-e39871297ccc', NOW(), 0, null, 3),
  ('082da7bb-ea0a-4365-be8f-f32d4013c725', 'Cristian Aldo', 'Abad Herrera', '1995-07-15', 'Dirección 1', 0, '87654321', 'isil20203', 'aldoabadh@gmail.com', '931392425', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('22dc64a6-e31a-4fd7-9d7b-500485f535a9', 'Oscar Elias', 'Alanya Valdivia', '1998-05-20', 'Dirección 2', 0, '12345678', 'isil20203', 'alanyaoscar9@gmail.com', '914048885', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('804bad8f-af85-46e4-9791-93476775bd26', 'Steven Stuwart', 'Atahua Diaz', '1992-09-18', 'Dirección 3', 0, '88776655', 'isil20203', 'exioauditrore@gmail.com', '970377096', '22e61128-f892-43be-a607-9d3f90c16f51', NOW(), 0, null, 3),
  ('af7043b6-84c6-48b7-a757-54fcb7c0599f', 'Dante Alejandro', 'Bernia Santiago', '1990-12-05', 'Dirección 4', 0, '43123221', 'isil20203', 'DANTEZZ_FENIX@HOTMAIL.COM', '910358919', 'b4622d94-58ad-4b90-bfd7-e39871297ccc', NOW(), 0, null, 3),
  ('40686998-207f-4a11-90bb-5f9c3d8a124b', 'Dain Jair', 'Caja Corrales', '1995-03-21', 'Dirección 5', 0, '44661122', 'isil20203', 'daincaja02@gmail.com', '988687630', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('c3ed56fc-adac-4077-a190-2bd176b857f3', 'Juanjose Alonso', 'Campos Sauñi', '1993-11-08', 'Dirección 6', 0, '61446622', 'isil20203', 'juan988205225@gmail.com', '957375272', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('9b8c5180-fde5-4bf5-8b39-b6f657a130a2', 'Henrique', 'Carhuapoma Capillo', '1996-04-17', 'Dirección 7', 0, '66002265', 'isil20203', 'henrike-9@hotmail.com', '902382106', '22e61128-f892-43be-a607-9d3f90c16f51', NOW(), 0, null, 3),
  ('5bc6549a-ccaf-4d3c-9d2d-da7b5da6a705', 'Jhezmain Ambrajhaham', 'Carranza Perales', '1997-08-24', 'Dirección 8', 0, '66112202', 'isil20203', 'xxjhezmainxx@hotmail.com', '992897161', 'b4622d94-58ad-4b90-bfd7-e39871297ccc', NOW(), 0, null, 3),
  ('85a09be4-467e-460d-a3d0-686996defe0a', 'Piero', 'Carrillo Malla', '1991-06-30', 'Dirección 9', 0, '55112531', 'isil20203', 'pierocarrillomalla35@gmail.com', '940693456', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('7148fb47-fadf-422e-a6ec-c08dffd69fc8', 'Yeremi', 'Carrion Bazan', '2000-02-14', 'Dirección 10', 0, '99662211', 'isil20203', 'yeremi.carrion.bazan@gmail.com', '986410108', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('473440a6-2487-4f9f-a264-3475fd964bb3', 'Ximena Ariana', 'Casas Rojas', '1999-11-29', 'Dirección 11', 0, '55331165', 'isil20203', 'xcasasrojas@gmail.com', '997762667', '22e61128-f892-43be-a607-9d3f90c16f51', NOW(), 0, null, 3),
  ('2cda6a81-2ff3-4e49-93cb-f1ccd48cf1af', 'Diego Antonio', 'Chavez Oliva', '1994-03-10', 'Dirección 12', 0, '99819021', 'isil20203', 'daco2200g@gmail.com', '948396536', 'b4622d94-58ad-4b90-bfd7-e39871297ccc', NOW(), 0, null, 3),
  ('627c434f-fb76-424e-a426-d24048858e90', 'Mario Francisco', 'Chumbes Santillan', '1996-07-25', 'Dirección 13', 0, '88554422', 'isil20203', 'zzzphoenixzzz@gmail.com', '942758677', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('3c02a582-2453-4d98-aecb-b89bbc7c55a2', 'Anthony Fernando', 'Espinoza Curay', '1997-05-06', 'Dirección 14', 0, '14234576', 'isil20203', 'Fernando40053@gmail.com', '931316526', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('3f85a681-78b2-477c-9d54-452a9fd78634', 'Fanny Marion', 'Fernandez Castillo', '1993-09-14', 'Dirección 15', 0, '15154321', 'isil20203', 'sheryssefc@gmail.com', '993083985', '22e61128-f892-43be-a607-9d3f90c16f51', NOW(), 0, null, 3),
  ('b33f4114-dac5-40b2-99d4-75e323328cce', 'Leonardo Marco Antonio', 'Flores Mendizabal', '1998-01-27', 'Dirección 16', 0, '16164321', 'isil20203', 'ztleozt@gmail.com', '916528716', 'b4622d94-58ad-4b90-bfd7-e39871297ccc', NOW(), 0, null, 3),
  ('47c0a71f-d458-4c14-96e9-43b28ce2ee51', 'Gabriela Fernanda', 'Francia Huapaya', '1997-03-20', 'Dirección 17', 0, '17174332', 'isil20203', 'gabriela20_03@outlook.es', '913056177', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('3f0c6bfc-cd34-4d13-ab19-9f7a11cccc35', 'Jesus Andres', 'Garcia Ventocilla', '1991-06-15', 'Dirección 18', 0, '18185402', 'isil20203', 'jesus_2106@hotmail.com', '999999999', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('2ce1bed7-3d30-456c-9985-6a96da971254', 'Edwin Ronald', 'Gonzales Rumaldo', '1994-08-28', 'Dirección 19', 0, '19196587', 'isil2023', 'r.e.gonzalesrumaldo@gmail.com', '976284647', '22e61128-f892-43be-a607-9d3f90c16f51', NOW(), 0, null, 3),
  ('040f755f-a4e2-41b0-9a00-48e06fa3c230', 'Alvaro', 'Guerrero Laureano', '1997-12-19', 'Dirección 20', 0, '20209842', 'isil2023', 'CAZADOR_DIURNO7@HOTMAIL.COM', '975199287', 'b4622d94-58ad-4b90-bfd7-e39871297ccc', NOW(), 0, null, 3),
  ('88c293d7-dfb6-4b53-8c43-00fd126603b2', 'Joseph Christian', 'Hidalgo Rivera', '1998-10-01', 'Dirección 21', 0, '21215465', 'isil2023', 'joseph_ultra@hotmail.com', '972322932', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('e1b63ede-a499-4da6-ba6a-d726e1d32c4b', 'Flavio Sebastian', 'Lecca Chavez', '1993-02-28', 'Dirección 22', 0, '54222221', 'isil2023', 'fla.lecca31@gmail.com', '992266654', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('693e0184-39d9-4587-9215-fdad2fc227d7', 'Luis Alberto', 'Moreno Loayza', '1990-11-03', 'Dirección 24', 0, '24245343', 'isil2023', 'luis_moreno_tvl@hotmail.com', '927031849', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('420a728a-1d5c-474c-b83d-ce0e242eea56', 'Cesar Raul', 'Nolasco Huamanchumo', '1991-12-20', 'Dirección 25', 0, '25256544', 'isil2023', 'ravlcesar.kiravl@gmail.com', '940126875', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3), /**/
  ('6c73d5ff-9df1-4af8-866c-e98212a99c45', 'Moises Antonio', 'Olivo Tarazona', '1996-03-05', 'Dirección 26', 0, '26265676', 'isil2023', 'MOISESOLIVO8@GMAIL.COM', '965623587', 'b4622d94-58ad-4b90-bfd7-e39871297ccc', NOW(), 0, null, 3),
  ('74c966c7-e37b-430a-89a8-f509bd5f51f4', 'Elizabeth Silvia', 'Pumacota Quispe', '1998-11-27', 'Dirección 27', 0, '27275655', 'isil2023', 'elizabethsilvia.15@gmail.com', '968737189', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('00758d7a-323a-4983-8148-ecf441015ccf', 'Mauricio Sebastian', 'Quiñe Angeles', '1991-07-10', 'Dirección 28', 0, '28298421', 'isil2023', 'mfagot91@hotmail.com', '942609309', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('657d3dab-1ea3-4475-b91a-29e8486b737e', 'Manuel Alexander', 'Reyna Crisostomo', '1995-12-14', 'Dirección 29', 0, '29298431', 'isil2023', 'mcrisos_reyna@hotmail.com', '980378418', '22e61128-f892-43be-a607-9d3f90c16f51', NOW(), 0, null, 3),
  ('d86de909-f5d4-4507-8c18-c770aa4e7e9c', 'Joel Eduardo', 'Rincon Rodriguez', '1996-08-03', 'Dirección 30', 0, '30309029', 'isil2023', 'joelrincon19@gmail.com', '915232590', 'b4622d94-58ad-4b90-bfd7-e39871297ccc', NOW(), 0, null, 3),
  ('de47d43e-86a1-4426-a747-21fe8e6b5c40', 'Fabián Jesús', 'Rivera Huamani', '1994-02-22', 'Dirección 31', 0, '31315630', 'isil2023', 'jesianrh@gmail.com', '964358989', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('d89d44b5-9ac7-4483-8f1f-910903523380', 'Diego Alberto', 'Rojas Mijahuanca', '1997-01-05', 'Dirección 32', 0, '32325412', 'isil2023', 'diego.rojas.15294@gmail.com', '928871966', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('ea656bba-e10d-469c-b683-137ca3f56709', 'Jessica Milagros', 'Vicente Maiz', '1996-06-15', 'Dirección 33', 0, '33334212', 'isil2023', 'jessicavicentemaiz@gmail.com', '970425478', '22e61128-f892-43be-a607-9d3f90c16f51', NOW(), 0, null, 3),
  ('c6f1e608-6799-4230-a2ca-17a295c916c0', 'Cielo Emilce', 'Yucra Garay', '1993-03-29', 'Dirección 34', 0, '34345414', 'isil2023', 'cielo.emilce29@gmail.com', '947301307', '104845f4-1120-40a9-9027-484ffbe4f3a1', NOW(), 0, null, 3),
  ('6b75f688-a34b-4990-8556-79f793cfef79', 'Pablo Romario', 'Zapata Guillermo', '1992-12-08', 'Dirección 35', 0, '35356677', 'isil2023', 'romahhzg@gmail.com', '961433226', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('86918e8f-9bbc-4f57-913b-92677220cd3c', 'Laura', 'Gomez Rodriguez', '1985-03-15', 'Calle Principal 123', 0, '53345678', 'password123', 'laura@gmail.com', '987654321', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('dcca64ec-56b7-47d1-b30a-dd6c46a949b1', 'Carlos', 'Lopez Fernandez', '1982-07-10', 'Avenida Central 456', 0, '23454189', 'password456', 'carlos@gmail.com', '987654322', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('9b69481b-67bc-47c4-8ead-9e96f6bc9104', 'Ana', 'Perez Sanchez', '1988-01-20', 'Calle Secundaria 789', 0, '34561290', 'password789', 'ana@gmail.com', '987654323', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('cb73abc1-8bf2-4d72-af4b-ab49ce3f480a', 'Pedro', 'Torres Martinez', '1990-09-05', 'Calle Principal 567', 0, '41278901', 'password901', 'pedro@gmail.com', '987654324', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('11500591-f07e-4171-98f9-2c4b75454e03', 'María', 'Garcia Lopez', '1983-04-12', 'Avenida Norte 789', 0, '56783112', 'password012', 'maria@gmail.com', '987654325', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('64ab23c4-aced-4b99-a9ca-7a544471fb66', 'Javier', 'Diaz Rodriguez', '1992-11-18', 'Calle Secundaria 234', 0, '61890123', 'password123', 'javier@gmail.com', '987654326', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('0a9e8d54-f39f-4365-9921-76480490e92e', 'Sofia', 'Fernandez Perez', '1987-06-25', 'Avenida Sur 567', 0, '78901414', 'password234', 'sofia@gmail.com', '987654327', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('8be43ba1-4940-460b-9f43-21762269cb42', 'Manuel', 'Lopez Torres', '1993-02-03', 'Calle Principal 678', 0, '89012345', 'password345', 'manuel@gmail.com', '987654328', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('8d6afedd-c2b9-42b9-aba6-977b7cdda24e', 'Luis', 'Sanchez Diaz', '1981-10-08', 'Avenida Oeste 123', 0, '90123456', 'password456', 'luis@gmail.com', '987654329', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('2896dbd6-d784-4ff5-86ae-5da1b2768d0c', 'Elena', 'Martinez Garcia', '1989-12-30', 'Calle Secundaria 789', 0, '12345644', 'password567', 'elena@gmail.com', '987654330', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('7fec0701-644a-4f50-9d61-0a66ecea14dd', 'Roberto', 'Rodriguez Lopez', '1984-08-14', 'Avenida Norte 234', 0, '23456712', 'password678', 'robertoro@gmail.com', '987654331', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('99bde076-58e8-4989-9c5f-59613b955bcc', 'Carmen', 'Perez Fernandez', '1994-05-27', 'Calle Principal 567', 0, '34567890', 'password789', 'carmen@gmail.com', '987654332', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('04c4edf4-aa9c-485e-8f1c-383f36f17cc1', 'Diego', 'Torres Martinez', '1991-03-09', 'Avenida Sur 678', 0, '45678904', 'password890', 'diego@gmail.com', '987654333', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('37008c62-df5e-4171-89c9-94b2e5d2154e', 'Isabel', 'Garcia Diaz', '1986-09-02', 'Calle Secundaria 123', 0, '56785212', 'password901', 'isabel@gmail.com', '987654334', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('9b541a3e-a9e3-49af-8f56-4d4d0caf537e', 'Andres', 'Diaz Rodriguez', '1980-11-16', 'Avenida Norte 345', 0, '67892323', 'password012', 'andres@gmail.com', '987654335', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('1597db82-e40a-421e-864b-a99b541e8348', 'Patricia', 'Fernandez Perez', '1987-07-01', 'Calle Principal 678', 0, '74201234', 'password123', 'patricia@gmail.com', '987654336', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('10b26fb3-7f1e-413c-97be-2af8d1ced4b9', 'Roberto', 'Lopez Torres', '1985-04-23', 'Avenida Oeste 789', 0, '89012215', 'password234', 'robertolo@gmail.com', '987654337', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('b01e31d8-9362-488e-b0c0-b42c8c2702dd', 'Marta', 'Sanchez Diaz', '1982-12-10', 'Calle Secundaria 123', 0, '90125256', 'password345', 'marta@gmail.com', '987654338', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('1ada31f2-5d15-4cfa-91a1-a9ec984ee859', 'Raul', 'Martinez Garcia', '1995-08-07', 'Avenida Sur 234', 0, '12345632', 'password456', 'raul@gmail.com', '987654339', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3),
  ('2bcf601e-d34b-4f44-85c2-c301a02363fd', 'Silvia', 'Rodriguez Lopez', '1990-01-04', 'Calle Principal 567', 0, '23465789', 'password567', 'silvia@gmail.com', '987654340', '8479031d-0693-4b3f-9bba-ce0521284d01', NOW(), 0, null, 3);

/* admin */
INSERT INTO users values ('83b7785f-6f65-11ee-ab19-0242ac110002', 'Manuel', 'Peña Lopez', '1885-05-24', 'Av los admins', '99412243', 0, 'admin123', 'admin@isil.pe', null, now(), 0, 1, null, null);

INSERT INTO courses (id_course, course_name, credits, description, syllabus, user_creation)
VALUES
	('4bd14b81-e79e-445a-83eb-82980726eb26', 'Cálculo para Ciencias e Ingeniería', 3, 'El curso de "Cálculo para Ciencias e Ingeniería" es un enfoque integral que combina teoría y práctica para proporcionar a los estudiantes las habilidades necesarias en el ámbito del cálculo, con un enfoque específico en su aplicación en las ciencias y la ingeniería.', 'calculo-para-ciencias-e-ingenieria.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('1ad1366a-5cbb-4340-b45f-410f045b6b00', 'Comunicación Escrita', 2, 'El curso de "Comunicación Escrita" se enfoca en desarrollar las habilidades de redacción y comunicación efectiva en entornos académicos y profesionales. Los estudiantes aprenderán a expresar sus ideas de manera clara y coherente.', 'comunicacion-escrita.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('8b94a716-f4ee-4660-9cd8-61ffee8f9610', 'Matemática Aplicada de las Cosas', 3, 'El curso de "Matemática Aplicada de las Cosas" se centra en la aplicación de conceptos matemáticos en situaciones del mundo real, especialmente en el contexto de la tecnología y la ciencia.', 'matematica-aplicada-de-las-cosas.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('9135035c-0788-4d17-ace8-6f0546c497c3', 'Gestión de Dispositivos Tecnológicos', 4, 'Este curso aborda la gestión de dispositivos tecnológicos, incluyendo la planificación, implementación y mantenimiento de infraestructuras tecnológicas en empresas y organizaciones.', 'gestion-de-dispositivos-tecnologicos.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('1eaec303-4921-48cf-aeb1-cea54393125b', 'Seguridad y Continuidad de Sistemas', 3, 'El curso de "Seguridad y Continuidad de Sistemas" se enfoca en la protección de sistemas informáticos y la planificación para garantizar la continuidad de operaciones en situaciones adversas.', 'seguridad-y-continuidad-de-sistemas.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('5ec96936-63f7-4c16-aae5-82133b74befb', 'Gestión de Proyectos', 3, 'Este curso se centra en los principios y prácticas de gestión de proyectos, preparando a los estudiantes para liderar y ejecutar proyectos tecnológicos de manera efectiva.', 'gestion-de-proyectos.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('414a02de-d41f-4832-b142-8afb8eb32361', 'Fundamentos de Marketing', 2, 'Este curso introduce los conceptos fundamentales de marketing, incluyendo estrategias de mercado, segmentación de clientes y promoción de productos y servicios.', 'fundamentos-de-marketing.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('f5494257-ad5f-4962-95ae-19e4a1d15714', 'Ética Profesional', 2, 'Este curso explora cuestiones éticas en el campo de la tecnología y la ingeniería, preparando a los estudiantes para tomar decisiones éticas en su futura carrera profesional.', 'etica-profesional.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('491e39bc-0827-4a3d-9a44-179b6292cbd9', 'Competencias Intrapersonales', 2, 'El curso de "Competencias Intrapersonales" se centra en el desarrollo de habilidades personales y profesionales, como la autoevaluación, la comunicación efectiva y el trabajo en equipo.', 'competencias-intrapersonales.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('f932f948-d7d5-449a-8561-bc8e353bc330', 'Gestión de la Creatividad e Innovación', 3, 'Este curso explora el proceso de gestión de la creatividad y la innovación en el contexto empresarial y tecnológico, fomentando la generación de ideas innovadoras.', 'gestion-de-la-creatividad-e-innovacion.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('58143065-56d6-4c45-b9f0-8120bb11bcca', 'Desarrollo de Resiliencia', 2, 'El curso de "Desarrollo de Resiliencia" se enfoca en la capacidad de enfrentar desafíos y adversidades de manera efectiva, promoviendo la resiliencia en situaciones personales y profesionales.', 'desarrollo-de-resiliencia.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('eef7f963-daa9-4151-b770-c20a8271bdd3', 'Dirección de Personas', 3, 'Este curso aborda la gestión de recursos humanos y el liderazgo de equipos en entornos tecnológicos y empresariales.', 'direccion-de-personas.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('5df91abb-1655-49bb-8c13-186b2b1e3efc', 'Diseño y Desarrollo Web', 3, 'El curso de "Diseño y Desarrollo Web" se enfoca en la creación de sitios web efectivos, incluyendo aspectos de diseño visual, usabilidad y programación web.', 'diseno-y-desarrollo-web.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('c7e22a28-9688-409e-9995-dbe87ceca741', 'Soluciones Basadas en Internet de las Cosas', 4, 'El curso de "Soluciones Basadas en Internet de las Cosas" explora cómo crear soluciones tecnológicas utilizando dispositivos IoT y plataformas de conectividad.', 'soluciones-basadas-en-iot.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('3aa51a30-b3b2-47bd-a439-e41f1994e0a5', 'Introducción a la Programación', 2, 'Este curso es una introducción a los conceptos fundamentales de la programación, incluyendo algoritmos, estructuras de datos y lenguajes de programación.', 'introduccion-a-la-programacion.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('b0cc01be-aff3-48ee-9833-474821f5a479', 'Algoritmo y Estructuras de Datos', 3, 'El curso de "Algoritmo y Estructuras de Datos" profundiza en la comprensión de algoritmos eficientes y estructuras de datos utilizadas en el desarrollo de software.', 'algoritmo-y-estructuras-de-datos.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('606dbea8-a491-40df-b4d5-02697fa47218', 'Diseño y Programación de Base de Datos', 3, 'Este curso se enfoca en el diseño y programación de bases de datos, preparando a los estudiantes para crear sistemas de gestión de datos efectivos.', 'diseno-y-programacion-de-base-de-datos.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('b9cdf0e0-2184-43bf-87e5-2627b2c48688', 'Análisis y Diseño de Sistemas I', 3, 'El curso de "Análisis y Diseño de Sistemas I" se centra en los conceptos y metodologías para analizar y diseñar sistemas de software, incluyendo diagramas de flujo y requisitos del sistema.', 'analisis-y-diseno-de-sistemas-i.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('c8c7859f-da74-4986-9391-b9079043f9c1', 'Calidad y Pruebas de Software', 3, 'El curso de "Calidad y Pruebas de Software" se enfoca en la aseguramiento de la calidad del software y las estrategias de prueba para garantizar que las aplicaciones funcionen de manera eficiente y libre de errores.', 'calidad-y-pruebas-de-software.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('65310835-39a2-4e1e-8ef1-aedfe3933d9c', 'Inglés Extranjero I', 2, 'El curso de "Inglés Extranjero I" proporciona una introducción al idioma inglés, incluyendo gramática, vocabulario y conversación básica.', 'ingles-extranjero-i.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),

	('3c2e7478-cd8c-49c7-884b-5bee2fd1c3d1', 'Desarrollo de Aplicaciones I', 3, 'El curso de "Desarrollo de Aplicaciones I" se enfoca en la creación de aplicaciones de software, incluyendo conceptos de diseño de software y programación orientada a objetos.', 'desarrollo-de-aplicaciones-i.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('35d0aede-0d3c-4140-bea9-809068bf96fe', 'Desarrollo de Aplicaciones Móviles', 3, 'Este curso se enfoca en el desarrollo de aplicaciones móviles para diversas plataformas y dispositivos, incluyendo aspectos de diseño y usabilidad.', 'desarrollo-de-aplicaciones-moviles.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('327e25f2-7097-45e7-b915-285493fd8c50', 'Análisis del Entorno de Negocios', 2, 'El curso de "Análisis del Entorno de Negocios" proporciona una comprensión de los factores externos que afectan a las organizaciones y cómo analizarlos para tomar decisiones informadas.', 'analisis-del-entorno-de-negocios.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('3f0a6854-9503-4ab7-8d72-e3cc425adca8', 'Modelos de Negocios y Startups', 3, 'El curso de "Modelos de Negocios y Startups" se enfoca en el desarrollo y análisis de modelos de negocios innovadores, con un énfasis en las startups tecnológicas.', 'modelos-de-negocios-y-startups.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', 'Programación Web I', 3, 'El curso de "Programación Web I" se centra en la introducción a las tecnologías y conceptos fundamentales para desarrollar aplicaciones web. Los estudiantes aprenderán sobre HTML, CSS y JavaScript.', 'programacion-web-i.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('9f84abcb-0246-4a3f-8993-eaa621b44dc5', 'Desarrollo de Aplicaciones Empresariales I', 3, 'El curso de "Desarrollo de Aplicaciones Empresariales I" se centra en la creación de soluciones de software para empresas, incluyendo sistemas empresariales y bases de datos.', 'desarrollo-de-aplicaciones-empresariales-i.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('2642af00-6ea9-4df6-9c1b-1dd94091ed33', 'Inglés Extranjero II', 2, 'Este curso es una continuación de "Inglés Extranjero I" y se enfoca en el desarrollo de habilidades de comunicación en inglés en situaciones cotidianas.', 'ingles-extranjero-ii.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),

	('56b2dcd6-9e3d-4d44-9b54-daa55c4ce3a4', 'Programación Web II', 3, 'Este curso es una continuación de "Programación Web I" y profundiza en el desarrollo de aplicaciones web dinámicas utilizando tecnologías avanzadas como frameworks de JavaScript y backend.', 'programacion-web-ii.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('0a5bdac3-ca52-441a-bc2a-b6fd141de409', 'Desarrollo de Aplicaciones II', 3, 'Este curso es una continuación de "Desarrollo de Aplicaciones I" y se adentra en aspectos más avanzados del desarrollo de aplicaciones, incluyendo bases de datos y diseño de interfaces de usuario.', 'desarrollo-de-aplicaciones-ii.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('a23e57ea-529d-410e-841d-290a2862ec03', 'Aplicaciones Móviles para Android', 3, 'El curso de "Aplicaciones Móviles para Android" se enfoca en el desarrollo de aplicaciones para dispositivos Android utilizando lenguajes y herramientas específicas.', 'aplicaciones-moviles-para-android.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('415d6fcd-3292-4ff5-bb3f-82f67a5d9033', 'Aplicaciones Móviles para iPhone', 3, 'Este curso aborda el desarrollo de aplicaciones móviles para dispositivos iPhone y iOS, incluyendo el uso de Swift y herramientas de desarrollo de Apple.', 'aplicaciones-moviles-para-iphone.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', 'Desarrollo de Aplicaciones Empresariales II', 3, 'Este curso es una continuación de "Desarrollo de Aplicaciones Empresariales I" y profundiza en el desarrollo de sistemas empresariales y soluciones tecnológicas avanzadas.', 'desarrollo-de-aplicaciones-empresariales-ii.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('e8f84455-93ef-4583-921c-2f7f82ad42dd', 'Integración de Aplicaciones', 3, 'El curso de "Integración de Aplicaciones" explora cómo integrar sistemas y aplicaciones tecnológicas en entornos empresariales, garantizando la interoperabilidad.', 'integracion-de-aplicaciones.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('0ae79e89-7324-4de7-a1d5-73d9fec44e96', 'Desarrollo de Soluciones Cloud', 3, 'Este curso se enfoca en el desarrollo de aplicaciones y soluciones basadas en la nube, aprovechando plataformas y servicios en la nube.', 'desarrollo-de-soluciones-cloud.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('8a27a197-5bce-441f-887e-3e57b73eae1c', 'Proyecto Tecnológico', 4, 'El curso de "Proyecto Tecnológico" tiene como objetivo guiar a los estudiantes a través del proceso de formulación y ejecución de proyectos tecnológicos en entornos empresariales.', 'proyecto-tecnologico.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('4f71edc9-6c89-4812-81cf-8b5477c8541e', 'Programación Avanzada de Base de Datos', 3, 'El curso de "Programación Avanzada de Base de Datos" profundiza en el diseño y programación de bases de datos complejas, incluyendo optimización y seguridad.', 'programacion-avanzada-de-base-de-datos.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('5857f1fe-1a12-4f97-80fc-2e31af5d695c', 'Análisis y Diseño de Sistemas II', 3, 'Este curso es una continuación de "Análisis y Diseño de Sistemas I" y profundiza en las técnicas avanzadas de análisis y diseño de sistemas de software.', 'analisis-y-diseno-de-sistemas-ii.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),
	('20ad25e5-2ef1-4b57-9da4-23c7f0f59cd9', 'Inglés Extranjero III', 2, 'El curso de "Inglés Extranjero III" avanza en las habilidades de inglés, incluyendo comprensión auditiva y expresión oral y escrita.', 'ingles-extranjero-iii.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002'),

	('1fd08d7a-5395-4c1b-b3f1-81ff463ab64d', 'Analítica de Sistemas Empresariales', 3, 'Este curso explora el análisis de sistemas empresariales, incluyendo la recopilación y análisis de datos para mejorar la toma de decisiones en las organizaciones.', 'analitica-de-sistemas-empresariales.pdf', '83b7785f-6f65-11ee-ab19-0242ac110002');


/* igual pero para el admin === admin123 */
update users set password = '$2a$10$BOm6GwouvlF88FLq7auaIO9BzbUCtcDMfZ/zU9o2IyqAJ4x.Pb0ZC' where email = 'admin@isil.pe';

SELECT * FROM courses;
SELECT * FROM careers;
SELECT * FROM users where user_type = 1; -- admins

/* profesores */

INSERT INTO users (id_user, firstname, surnames, birthday, address, type_doc, doc_id, password, email, phone, id_career, register_date, state, photo, user_type)
VALUES
    ('6b32c6e3-6489-11ee-95e8-0242ac110002', 'Maria Maria', 'Becerra Garcia', '1995-10-03', 'Avenida Petit Thoars 5532', 0, '88432231', 'isil20203', 'becerra@gmail.com', null, null, NOW(), 0, null, 2),
    ('6114d88b-67b1-11ee-ad27-0242ac110002', 'Carlos', 'López Pérez', '1978-05-15', 'Calle Principal 123', 0, '73625115', 'isil20203', 'carlos@email.com', null, null, NOW(), 0, null, 2),
    ('667986a1-67b1-11ee-ad27-0242ac110002', 'Ana', 'Martínez Sánchez', '1982-09-20', 'Avenida Central 456', 0, '45678932', 'isil20203', 'ana@email.com', null, null, NOW(), 0, null, 2),
    ('786f8aa0-67b1-11ee-ad27-0242ac110002', 'Luis', 'Gómez Rodríguez', '1975-03-10', 'Calle Secundaria 789', 0, '32456501', 'isil20203', 'luis@email.com', null, null, NOW(), 0, null, 2),
    ('832e71d4-67b1-11ee-ad27-0242ac110002', 'María', 'Ramírez Fernández', '1980-07-08', 'Calle de la Paz 234', 0, '10123452', 'isil20203', 'maria@email.com', null, null, NOW(), 0, null, 2),
    ('86852909-67b1-11ee-ad27-0242ac110002', 'Pedro', 'Hernández López', '1973-12-30', 'Avenida Central 567', 0, '11245161', 'isil20203', 'pedro@email.com', null, null, NOW(), 0, null, 2),
    ('8bd385eb-67b1-11ee-ad27-0242ac110002', 'Laura', 'García Martínez', '1985-06-25', 'Calle de los Sueños 345', 0, '65412345', 'isil20203', 'laura@email.com', null, null, NOW(), 0, null, 2),
    ('900f0306-67b1-11ee-ad27-0242ac110002', 'Javier', 'Fernández López', '1976-02-14', 'Calle del Sol 678', 0, '78012345', 'isil20203', 'javier@email.com', null, null, NOW(), 0, null, 2),
    ('95335f24-67b1-11ee-ad27-0242ac110002', 'Carmen', 'López Gómez', '1981-08-03', 'Calle Principal 123', 0, '45123451', 'isil20203', 'carmen@email.com', null, null, NOW(), 0, null, 2),
    ('9b686b27-67b1-11ee-ad27-0242ac110002', 'Miguel', 'Sánchez Rodríguez', '1977-04-22', 'Avenida Central 456', 0, '12344345', 'isil20203', 'miguel@email.com', null, null, NOW(), 0, null, 2),
    ('a05967ce-67b1-11ee-ad27-0242ac110002', 'Isabel', 'Martínez López', '1979-11-01', 'Calle Secundaria 789', 0, '54782211', 'isil20203', 'isabel@email.com', null, null, NOW(), 0, null, 2),
    ('a7e2efdf-67b1-11ee-ad27-0242ac110002', 'Ricardo', 'Gómez Sánchez', '1984-10-18', 'Calle de la Paz 234', 0, '54434457', 'isil20203', 'ricardo@email.com', null, null, NOW(), 0, null, 2),
    ('aefbc60d-67b1-11ee-ad27-0242ac110002', 'Elena', 'Hernández Rodríguez', '1972-01-05', 'Avenida Central 567', 0, '54565122', 'isil20203', 'elena@email.com', null, null, NOW(), 0, null, 2),
    ('b23cadfe-67b1-11ee-ad27-0242ac110002', 'Antonio', 'Martínez Pérez', '1986-07-30', 'Calle de los Sueños 345', 0, '55134244', 'isil20203', 'antonio@email.com', null, null, NOW(), 0, null, 2),
    ('b77bdf1b-67b1-11ee-ad27-0242ac110002', 'Patricia', 'Sánchez López', '1974-03-12', 'Calle del Sol 678', 0, '50022512', 'isil20203', 'patricia@email.com', null, null, NOW(), 0, null, 2),
    ('bbc82d5a-67b1-11ee-ad27-0242ac110002', 'Juan', 'López Rodríguez', '1983-09-15', 'Calle Principal 123', 0, '90902515', 'isil20203', 'juan@email.com', null, null, NOW(), 0, null, 2),
    ('bfab5004-67b1-11ee-ad27-0242ac110002', 'Sofía', 'Martínez García', '1978-06-29', 'Avenida Central 456', 0, '48226458', 'isil20203', 'sofia@email.com', null, null, NOW(), 0, null, 2),
    ('c4e9e4f6-67b1-11ee-ad27-0242ac110002', 'Manuel', 'Hernández López', '1980-05-08', 'Calle de la Paz 234', 0, '78932456', 'isil20203', 'manuel@email.com', null, null, NOW(), 0, null, 2),
    ('c93c58d9-67b1-11ee-ad27-0242ac110002', 'Marina', 'García Rodríguez', '1975-11-11', 'Calle del Sol 789', 0, '23456341', 'isil20203', 'marina@email.com', null, null, NOW(), 0, null, 2),
    ('cdd3b0e3-67b1-11ee-ad27-0242ac110002', 'Francisco', 'López Martínez', '1982-04-04', 'Avenida Principal 456', 0, '99531432', 'isil20203', 'francisco@email.com', null, null, NOW(), 0, null, 2),
    ('d164d12a-67b1-11ee-ad27-0242ac110002', 'Eva', 'Martínez Pérez', '1973-08-25', 'Calle de la Luna 123', 0, '62156166', 'isil20203', 'eva@email.com', null, null, NOW(), 0, null, 2),
    ('d6dcd93f-67b1-11ee-ad27-0242ac110002', 'Alejandro', 'Gómez Sánchez', '1981-02-14', 'Avenida Central 789', 0, '43224456', 'isil20203', 'alejandro@email.com', null, null, NOW(), 0, null, 2),
    ('db952d86-67b1-11ee-ad27-0242ac110002', 'Isabella', 'López Rodríguez', '1976-05-19', 'Calle Principal 456', 0, '50112351', 'isil20203', 'isabella@email.com', null, null, NOW(), 0, null, 2),
    ('e099261b-67b1-11ee-ad27-0242ac110002', 'Fernando', 'García Martínez', '1980-12-10', 'Avenida del Sol 789', 0, '12341234', 'isil20203', 'fernando@email.com', null, null, NOW(), 0, null, 2),
    ('e575ee7c-67b1-11ee-ad27-0242ac110002', 'Natalia', 'Martínez Sánchez', '1977-07-06', 'Calle de la Playa 123', 0, '12124568', 'isil20203', 'natalia@email.com', null, null, NOW(), 0, null, 2),
    ('ebb8ffb7-67b1-11ee-ad27-0242ac110002', 'Raúl', 'Gómez López', '1984-09-28', 'Avenida del Río 456', 0, '56783333', 'isil20203', 'raul@email.com', null, null, NOW(), 0, null, 2),
    ('f0482352-67b1-11ee-ad27-0242ac110002', 'Clara', 'Hernández García', '1979-11-23', 'Calle del Bosque 123', 0, '78912341', 'isil20203', 'clara@email.com', null, null, NOW(), 0, null, 2),
    ('f5884c02-67b1-11ee-ad27-0242ac110002', 'Roberto', 'Martínez Rodríguez', '1983-06-21', 'Avenida Principal 789', 0, '12344511', 'isil20203', 'roberto@email.com', null, null, NOW(), 0, null, 2),
    ('f97ad5f8-67b1-11ee-ad27-0242ac110002', 'Sara', 'García López', '1978-03-17', 'Calle de la Montaña 123', 0, '10010032', 'isil20203', 'sara@email.com', null, null, NOW(), 0, null, 2),
    ('fdf6befb-67b1-11ee-ad27-0242ac110002', 'Andrés', 'López Sánchez', '1982-01-09', 'Avenida del Mar 456', 0, '56230033', 'isil20203', 'andres@email.com', null, null, NOW(), 0, null, 2),
    ('0211c8be-67b2-11ee-ad27-0242ac110002', 'Valeria', 'Gómez Martínez', '1974-07-14', 'Calle de la Estrella 123', 0, '62311115', 'isil20203', 'valeria@email.com', null, null, NOW(), 0, null, 2);

/* constraseña hasheada para spring boot == isil20203, para todos los alumnos */
update users set password = '$2a$10$YmI8mkcnKEAhQKnot.gGgOFUHRAeKwy10iHm00MVS14Q2aqHTB6FC' where user_type = 3 OR user_type = 2;

CREATE VIEW classroom_view as
SELECT c.id_classroom, c.nrc, c.school_day, c.start_time, c.end_time, c.link_meet, c.total_hours,
    CASE
        WHEN c.modality = 1 THEN 'VIRTUAL'
        WHEN c.modality = 2 THEN 'REMOTO'
        WHEN c.modality = 3 THEN 'SEMIREMOTO'
        ELSE 'PRESENCIAL'
    END AS modality, c.campus, c.period, c.start_date, c.end_date, c.max_members, c.id_teacher,
    concat(u.firstname, ' ', u.surnames) teacher, c.id_course, c2.course_name course
FROM classrooms c INNER JOIN users u on c.id_teacher = u.id_user
INNER JOIN courses c2 on c.id_course = c2.id_course;

UPDATE courses SET syllabus = 'https://res.cloudinary.com/durrquwiy/image/upload/v1696636531/syllabus/30015-SILABO_tsaov5.pdf';
SELECT * FROM users where user_type = 1; -- admins

-- Insertar contenido para el curso "Programación Web I"
INSERT INTO contents (title, description, link_file, num_order, id_course, user_creation)
VALUES
    ('Introducción a HTML', 'Introducción a HTML y su importancia en el desarrollo web.', 'html-intro.ppt', 1, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Fundamentos de CSS', 'Fundamentos de CSS para dar estilo a páginas web.', 'css-fundamentals.ppt', 2, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('JavaScript Básico', 'Introducción a JavaScript y su uso en páginas web interactivas.', 'javascript-basico.ppt', 3, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Diseño Responsivo', 'Conceptos y técnicas de diseño web responsivo.', 'diseno-responsivo.ppt', 4, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Frameworks Frontend', 'Introducción a los frameworks frontend para el desarrollo web.', 'frontend-frameworks.ppt', 5, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Programación en jQuery', 'Uso de jQuery para la manipulación del DOM en aplicaciones web.', 'jquery-programming.ppt', 6, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Trabajo con APIs', 'Cómo interactuar con APIs en aplicaciones web.', 'api-usage.ppt', 7, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Bases de Datos en la Web', 'Uso de bases de datos en el desarrollo web.', 'web-databases.ppt', 8, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Seguridad Web', 'Conceptos de seguridad en aplicaciones web y buenas prácticas.', 'web-security.ppt', 9, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Despliegue Web', 'Cómo desplegar aplicaciones web en servidores en línea.', 'web-deployment.ppt', 10, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Introducción a Node.js', 'Introducción a Node.js para el desarrollo de aplicaciones web del lado del servidor.', 'nodejs-intro.ppt', 11, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Frameworks Backend', 'Uso de frameworks backend en el desarrollo web.', 'backend-frameworks.ppt', 12, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Seguridad en Node.js', 'Prácticas de seguridad en aplicaciones Node.js.', 'nodejs-security.ppt', 13, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Aplicaciones en Tiempo Real', 'Desarrollo de aplicaciones web en tiempo real.', 'real-time-web.ppt', 14, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Proyecto de Desarrollo Web', 'Desarrollo de un proyecto web completo.', 'web-dev-project.ppt', 15, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('Evaluación Final', 'Evaluación final del curso de Programación Web I.', 'evaluacion-final.ppt', 16, 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002');


INSERT INTO classrooms
    (id_classroom, nrc, school_day, start_time, end_time, link_meet, total_hours, modality,
     campus, period, start_date, end_date, max_members, id_teacher, id_course, user_creation)
VALUES
    ('2c5fa398-67b2-11ee-ad27-0242ac110002', '2122', 'Lunes', '08:00:00', '09:50:00', 'https://meet.google.com/link1', 2, 2, 'MIRAFLORES', '202320', '2023-04-05','2023-12-21', 30, '0211c8be-67b2-11ee-ad27-0242ac110002', '0a5bdac3-ca52-441a-bc2a-b6fd141de409', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('30974fb2-67b2-11ee-ad27-0242ac110002', '1900', 'Martes', '09:00:00', '10:50:00', 'https://meet.google.com/link2', 2, 2, 'SAN ISIDRO', '202320', '2023-04-05', '2023-12-21', 25, '0211c8be-67b2-11ee-ad27-0242ac110002', '0a5bdac3-ca52-441a-bc2a-b6fd141de409', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('3502ee35-67b2-11ee-ad27-0242ac110002', '3133', 'Miércoles', '13:00:00', '14:50:00', 'https://meet.google.com/link3', 2, 2, 'LA MOLINA', '202320', '2023-04-05', '2023-12-21', 35, '0211c8be-67b2-11ee-ad27-0242ac110002', '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('5a43a8dd-67b2-11ee-ad27-0242ac110002', '4343', 'Jueves', '14:00:00', '15:50:00', 'https://meet.google.com/link4', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 28, '0211c8be-67b2-11ee-ad27-0242ac110002', '1ad1366a-5cbb-4340-b45f-410f045b6b00', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('6ea3eaea-67b2-11ee-ad27-0242ac110002', '5432', 'Viernes', '10:00:00', '11:50:00', 'https://meet.google.com/link5', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 32, '0211c8be-67b2-11ee-ad27-0242ac110002', '1ad1366a-5cbb-4340-b45f-410f045b6b00', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('d1730cb1-67b8-11ee-ad27-0242ac110002', '2026', 'Lunes', '08:00:00', '09:50:00', 'https://meet.google.com/link1', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 30, 'ebb8ffb7-67b1-11ee-ad27-0242ac110002', '1fd08d7a-5395-4c1b-b3f1-81ff463ab64d', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('d5314494-67b8-11ee-ad27-0242ac110002', '1960', 'Martes', '09:00:00', '10:50:00', 'https://meet.google.com/link2', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 25, 'ebb8ffb7-67b1-11ee-ad27-0242ac110002', '0a5bdac3-ca52-441a-bc2a-b6fd141de409', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('d8180768-67b8-11ee-ad27-0242ac110002', '3143', 'Miércoles', '13:00:00', '14:50:00', 'https://meet.google.com/link3', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 35, 'ebb8ffb7-67b1-11ee-ad27-0242ac110002', '1fd08d7a-5395-4c1b-b3f1-81ff463ab64d', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('dbe74fd5-67b8-11ee-ad27-0242ac110002', '2521', 'Jueves', '10:00:00', '11:50:00', 'https://meet.google.com/link4', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 28, 'ebb8ffb7-67b1-11ee-ad27-0242ac110002', '0a5bdac3-ca52-441a-bc2a-b6fd141de409', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('e05a53b8-67b8-11ee-ad27-0242ac110002', '1231', 'Viernes', '14:00:00', '15:50:00', 'https://meet.google.com/link5', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 26, 'ebb8ffb7-67b1-11ee-ad27-0242ac110002', '1eaec303-4921-48cf-aeb1-cea54393125b', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('eb857224-67b8-11ee-ad27-0242ac110002', '1411', 'Viernes', '14:00:00', '15:50:00', 'https://meet.google.com/link10', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 26, 'fdf6befb-67b1-11ee-ad27-0242ac110002', '327e25f2-7097-45e7-b915-285493fd8c50', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('efd9b81b-67b8-11ee-ad27-0242ac110002', '3495', 'Sábado', '11:00:00', '12:50:00', 'https://meet.google.com/link11', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 30, 'fdf6befb-67b1-11ee-ad27-0242ac110002', '414a02de-d41f-4832-b142-8afb8eb32361', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('f8fc44a1-67b8-11ee-ad27-0242ac110002', '1663', 'Lunes', '16:00:00', '17:50:00', 'https://meet.google.com/link12', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 32, 'fdf6befb-67b1-11ee-ad27-0242ac110002', '327e25f2-7097-45e7-b915-285493fd8c50', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('fd1401a0-67b8-11ee-ad27-0242ac110002', '4880', 'Martes', '15:00:00', '16:50:00', 'https://meet.google.com/link13', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 28, 'fdf6befb-67b1-11ee-ad27-0242ac110002', '414a02de-d41f-4832-b142-8afb8eb32361', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('01faefd5-67b9-11ee-ad27-0242ac110002', '2773', 'Miércoles', '14:00:00', '15:50:00', 'https://meet.google.com/link14', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 26, 'fdf6befb-67b1-11ee-ad27-0242ac110002', '327e25f2-7097-45e7-b915-285493fd8c50', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('07de7e31-67b9-11ee-ad27-0242ac110002', '3115', 'Sábado', '11:00:00', '12:50:00', 'https://meet.google.com/link15', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 30, '900f0306-67b1-11ee-ad27-0242ac110002', '4f71edc9-6c89-4812-81cf-8b5477c8541e', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('0bffd540-67b9-11ee-ad27-0242ac110002', '1333', 'Lunes', '16:00:00', '17:50:00', 'https://meet.google.com/link16', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 32, '900f0306-67b1-11ee-ad27-0242ac110002', '5857f1fe-1a12-4f97-80fc-2e31af5d695c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('0fe90147-67b9-11ee-ad27-0242ac110002', '4220', 'Martes', '15:00:00', '16:50:00', 'https://meet.google.com/link17', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 28, '900f0306-67b1-11ee-ad27-0242ac110002', '5857f1fe-1a12-4f97-80fc-2e31af5d695c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('15d8cf76-67b9-11ee-ad27-0242ac110002', '1053', 'Miércoles', '14:00:00', '15:50:00', 'https://meet.google.com/link18', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 26, '900f0306-67b1-11ee-ad27-0242ac110002', '4f71edc9-6c89-4812-81cf-8b5477c8541e', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('1a497a1b-67b9-11ee-ad27-0242ac110002', '2889', 'Jueves', '08:00:00', '09:50:00', 'https://meet.google.com/link19', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 24, 'e575ee7c-67b1-11ee-ad27-0242ac110002', 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('1dcbc595-67b9-11ee-ad27-0242ac110002', '2636', 'Viernes', '10:00:00', '11:50:00', 'https://meet.google.com/link20', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 28, 'e575ee7c-67b1-11ee-ad27-0242ac110002', 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('219f08d8-67b9-11ee-ad27-0242ac110002', '4515', 'Sábado', '14:00:00', '15:50:00', 'https://meet.google.com/link21', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 26, 'e575ee7c-67b1-11ee-ad27-0242ac110002', 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('249c4e1e-67b9-11ee-ad27-0242ac110002', '1811', 'Lunes', '09:00:00', '10:50:00', 'https://meet.google.com/link22', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 25, 'e575ee7c-67b1-11ee-ad27-0242ac110002', 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('2895bc3e-67b9-11ee-ad27-0242ac110002', '3027', 'Martes', '11:00:00', '12:50:00', 'https://meet.google.com/link23', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 30, 'e575ee7c-67b1-11ee-ad27-0242ac110002', 'f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('2c6a5420-67b9-11ee-ad27-0242ac110002', '1886', 'Viernes', '10:00:00', '11:50:00', 'https://meet.google.com/link24', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 28, 'e099261b-67b1-11ee-ad27-0242ac110002', 'eef7f963-daa9-4151-b770-c20a8271bdd3', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('3073975f-67b9-11ee-ad27-0242ac110002', '4655', 'Sábado', '14:00:00', '15:50:00', 'https://meet.google.com/link25', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 26, 'e099261b-67b1-11ee-ad27-0242ac110002', 'f5494257-ad5f-4962-95ae-19e4a1d15714', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('33801e22-67b9-11ee-ad27-0242ac110002', '1631', 'Lunes', '09:00:00', '10:50:00', 'https://meet.google.com/link26', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 25, 'e099261b-67b1-11ee-ad27-0242ac110002', 'f5494257-ad5f-4962-95ae-19e4a1d15714', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('37428f09-67b9-11ee-ad27-0242ac110002', '3667', 'Martes', '11:00:00', '12:50:00', 'https://meet.google.com/link27', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 30, 'e099261b-67b1-11ee-ad27-0242ac110002', 'eef7f963-daa9-4151-b770-c20a8271bdd3', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('3b69f861-67b9-11ee-ad27-0242ac110002', '1991', 'Lunes', '09:00:00', '10:50:00', 'https://meet.google.com/link28', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 25, 'db952d86-67b1-11ee-ad27-0242ac110002', 'b0cc01be-aff3-48ee-9833-474821f5a479', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('40d76b2e-67b9-11ee-ad27-0242ac110002', '3745', 'Martes', '11:00:00', '12:50:00', 'https://meet.google.com/link29', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 30, 'db952d86-67b1-11ee-ad27-0242ac110002', '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('459144aa-67b9-11ee-ad27-0242ac110002', '2666', 'Miércoles', '16:00:00', '17:50:00', 'https://meet.google.com/link30', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 28, 'db952d86-67b1-11ee-ad27-0242ac110002', '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('48d62d28-67b9-11ee-ad27-0242ac110002', '3912', 'Jueves', '15:00:00', '16:50:00', 'https://meet.google.com/link31', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 32, 'db952d86-67b1-11ee-ad27-0242ac110002', 'b0cc01be-aff3-48ee-9833-474821f5a479', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('4c683763-67b9-11ee-ad27-0242ac110002', '1653', 'Viernes', '14:00:00', '15:50:00', 'https://meet.google.com/link32', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 30, 'db952d86-67b1-11ee-ad27-0242ac110002', 'b0cc01be-aff3-48ee-9833-474821f5a479', '83b7785f-6f65-11ee-ab19-0242ac110002'),

    ('502e3352-67b9-11ee-ad27-0242ac110002', '5511', 'Miércoles', '16:00:00', '17:50:00', 'https://meet.google.com/link33', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 28, 'd6dcd93f-67b1-11ee-ad27-0242ac110002', '5df91abb-1655-49bb-8c13-186b2b1e3efc', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('54d54029-67b9-11ee-ad27-0242ac110002', '6664', 'Jueves', '15:00:00', '16:50:00', 'https://meet.google.com/link34', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 32, 'd6dcd93f-67b1-11ee-ad27-0242ac110002', '56b2dcd6-9e3d-4d44-9b54-daa55c4ce3a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('5800b821-67b9-11ee-ad27-0242ac110002', '5422', 'Viernes', '14:00:00', '15:50:00', 'https://meet.google.com/link35', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 30, 'd6dcd93f-67b1-11ee-ad27-0242ac110002', '56b2dcd6-9e3d-4d44-9b54-daa55c4ce3a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
    ('5d1a9187-67b9-11ee-ad27-0242ac110002', '3306', 'Sábado', '09:00:00', '10:50:00', 'https://meet.google.com/link36', 2, 2, 'REMOTO', '202320', '2023-04-05', '2023-12-21', 25, 'd6dcd93f-67b1-11ee-ad27-0242ac110002', '5df91abb-1655-49bb-8c13-186b2b1e3efc', '83b7785f-6f65-11ee-ab19-0242ac110002');



INSERT INTO contents
(title, description, link_file ,num_order,id_course, user_creation)
values
(' T01 - Computación en la nube','Conceptos basicos de computacion en la nube','',1,'0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
(' T02 - Servicios AWS', 'Explora los servicios de Amazon Web Services (AWS) y aprende cómo utilizarlos para desplegar aplicaciones y gestionar recursos en la nube.', '', 2, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T03 - Servicios informáticos y redes', 'Comprende los principios fundamentales de los servicios informáticos y las redes en el contexto de la computación en la nube, incluyendo conceptos como la virtualización y la configuración de redes en entornos virtuales.', '', 3, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T04 - Seguridad de arquitectura AWS', 'Profundiza en las mejores prácticas de seguridad en la arquitectura de Amazon Web Services, incluyendo la gestión de accesos, el cifrado de datos y la protección contra amenazas comunes en la nube.', '', 4, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T05 - Bucket S3', 'Descubre Amazon S3 (Simple Storage Service) y aprende a crear y gestionar buckets para almacenar y recuperar datos en la nube de manera escalable y segura.', '', 5, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T06 - RDS (parte 1)', 'Explora Amazon RDS (Relational Database Service) en la primera parte de esta serie, centrándote en la creación y gestión de bases de datos relacionales en la nube sin preocuparte por la infraestructura subyacente.', '', 6, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T07 - RDS (parte 2)', 'Continúa explorando Amazon RDS en la segunda parte, aprendiendo sobre la replicación de datos, la optimización del rendimiento y las estrategias de copia de seguridad para bases de datos en la nube.', '', 7, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T08 - Parcial', 'Realiza una evaluación parcial para poner a prueba tus conocimientos sobre los conceptos básicos de computación en la nube, incluyendo temas como servicios de AWS, seguridad y gestión de datos en la nube.', '', 8, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T09 - Biblioteca de códigos', 'Crea una biblioteca de códigos reutilizables para tus proyectos en la nube, explorando las mejores prácticas para el desarrollo de aplicaciones escalables y eficientes en AWS y otros servicios en la nube.', '', 9, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T10 - Operaciones de servicio', 'Aprende sobre las operaciones de servicio en la nube, incluyendo la monitorización, el escalado automático y la gestión de incidencias para garantizar el rendimiento y la disponibilidad de tus aplicaciones en la nube.', '', 10, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T11 - Modelos de seguridad', 'Explora los diversos modelos de seguridad en la nube, incluyendo la autenticación multifactor, la gestión de claves y los servicios de seguridad gestionada para proteger tus recursos y datos en entornos cloud.', '', 11, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T12 - Modelos de uso', 'Comprende los diferentes modelos de uso en la computación en la nube, incluyendo IaaS (Infraestructura como Servicio), PaaS (Plataforma como Servicio) y SaaS (Software como Servicio), y cómo elegir el enfoque adecuado para tus necesidades empresariales.', '', 12, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T13 - Arquitectura del proyecto', 'Diseña la arquitectura de un proyecto en la nube, considerando aspectos como la escalabilidad, la redundancia y la seguridad. Aprende a utilizar servicios específicos de AWS para implementar soluciones efectivas en la nube.', '', 13, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T14 - Implementación del proyecto', 'Ponte manos a la obra y lleva a cabo la implementación práctica del proyecto en la nube que has diseñado. Aplica tus conocimientos para desplegar aplicaciones, gestionar bases de datos y garantizar la seguridad en la nube.', '', 14, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T15 - Aplicación web del proyecto', 'Desarrolla una aplicación web completa utilizando tecnologías en la nube. Aprende sobre el desarrollo frontend y backend en entornos cloud, la gestión de datos y la integración con servicios web para crear una aplicación robusta y escalable.', '', 15, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T16 - Final', 'Completa el curso con un examen final que evaluará tus conocimientos sobre todos los aspectos de la computación en la nube que has aprendido. Demuestra tus habilidades en la planificación, implementación y gestión de soluciones en la nube.', '', 16, '0ae79e89-7324-4de7-a1d5-73d9fec44e96', '83b7785f-6f65-11ee-ab19-0242ac110002'),


('T01 - Java EE', 'Introducción a Java EE y sus conceptos básicos para el desarrollo de aplicaciones empresariales en la nube.', ' ', 1, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T02 - Componentes', 'Exploración de los componentes esenciales para el desarrollo y despliegue de aplicaciones en la nube utilizando Java EE.', ' ', 2, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T03 - Aplicativos web', 'Desarrollo de aplicaciones web dinámicas y escalables utilizando las tecnologías de Java EE.', ' ', 3, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T04 - Integración', 'Integración de aplicaciones y servicios web para mejorar la funcionalidad y eficiencia de las aplicaciones en la nube.', ' ', 4, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T05 - Inyección de dependencias', 'Conceptos avanzados de inyección de dependencias para mejorar la modularidad y mantenibilidad de las aplicaciones Java EE.', ' ', 5, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T06 - Spring Framework', 'Exploración del framework Spring para el desarrollo de aplicaciones empresariales robustas y flexibles en la nube.', ' ', 6, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T07 - Spring MVC', 'Desarrollo de aplicaciones web utilizando el patrón de diseño MVC en el contexto del framework Spring.', ' ', 7, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('Parcial', 'Evaluación parcial para evaluar la comprensión de los conceptos y tecnologías Java EE aprendidos hasta ahora.', ' ', 8, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T09 - Reconocimiento de librerías', 'Exploración de librerías y herramientas útiles para el desarrollo eficiente de aplicaciones Java EE en la nube.', ' ', 9, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T10 - Gestión de consultas', 'Gestión eficiente de consultas de bases de datos para mejorar el rendimiento y la eficiencia de las aplicaciones Java EE.', ' ', 10, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T11 - Gestión de transacciones', 'Implementación y gestión de transacciones en aplicaciones Java EE para garantizar la integridad de los datos.', ' ', 11, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T12 - Integración', 'Integración avanzada de sistemas y servicios en aplicaciones Java EE para una funcionalidad completa.', ' ', 12, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T13 - Servicios web', 'Desarrollo y consumo de servicios web en aplicaciones Java EE, incluyendo SOAP y REST.', ' ', 13, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T14 - Servicios REST', 'Implementación de servicios RESTful para la comunicación eficiente y escalable entre aplicaciones.', ' ', 14, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T15 - Tecnologías de integración', 'Exploración de tecnologías avanzadas para la integración de sistemas y aplicaciones en el entorno Java EE.', ' ', 15, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('Final', 'Examen final que evaluará el conocimiento y las habilidades adquiridas en todos los aspectos de Java EE para aplicaciones en la nube.', ' ', 16, '695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', '83b7785f-6f65-11ee-ab19-0242ac110002'),


('T01 - Inicio del proyecto', 'Introducción al proyecto y establecimiento de los objetivos iniciales. Comprende la definición del propósito del proyecto y la planificación inicial.', ' ', 1, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T02 - Visión del proyecto', 'Establecimiento de la visión del proyecto, identificando metas a largo plazo y los resultados esperados. Comprende la creación de una visión clara y comprensión de los objetivos finales.', ' ', 2, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T03 - Alcance del proyecto', 'Definición del alcance del proyecto, identificando los límites y las fronteras del trabajo a realizar. Comprende la determinación de qué está incluido y qué está excluido en el proyecto.', ' ', 3, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T04 - Planificación del Proyecto', 'Desarrollo detallado del plan del proyecto, incluyendo cronogramas, asignación de recursos y establecimiento de hitos clave. Comprende la planificación de las actividades y los recursos necesarios para el éxito del proyecto.', ' ', 4, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T05 - Modelamiento de solución tecnológica', 'Exploración y desarrollo del modelo tecnológico para el proyecto, incluyendo arquitectura, herramientas y tecnologías a utilizar. Comprende la identificación de soluciones tecnológicas adecuadas para los requisitos del proyecto.', ' ', 5, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T06 - Diseño de solución', 'Creación detallada del diseño del sistema, incluyendo diagramas, interfaces y estructuras de datos. Comprende la creación de un plano detallado para la implementación del proyecto.', ' ', 6, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T07 - Soluciones tecnológicas', 'Implementación y evaluación de soluciones tecnológicas para el proyecto, incluyendo herramientas y frameworks específicos. Comprende la aplicación de tecnologías para alcanzar los objetivos del proyecto.', ' ', 7, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('Parcial', 'Evaluación parcial para evaluar los conocimientos y habilidades adquiridos hasta este punto en el proyecto.', ' ', 8, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T09 - Versiones del proyecto', 'Gestión de versiones y control de cambios en el proyecto, incluyendo el seguimiento de las modificaciones y la documentación de versiones anteriores. Comprende la organización de diferentes versiones del proyecto durante su desarrollo.', ' ', 9, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T10 - Calidad de procesos', 'Implementación de procesos de control de calidad para garantizar la excelencia en la ejecución del proyecto. Comprende la aplicación de estándares de calidad y prácticas recomendadas.', ' ', 10, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T11 - Control de calidad', 'Evaluación y seguimiento continuo de la calidad del proyecto, incluyendo pruebas y revisión de los resultados. Comprende la identificación y corrección de posibles problemas y desviaciones.', ' ', 11, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T12 - Mejora continua', 'Implementación de procesos para la mejora continua del proyecto, incluyendo retroalimentación y ajuste constante. Comprende la identificación de áreas de mejora y la implementación de soluciones para optimizar el proyecto.', ' ', 12, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T13 - Trabajo colaborativo', 'Fomento del trabajo en equipo y la colaboración efectiva entre los miembros del proyecto. Comprende la promoción de la comunicación y la cooperación para lograr los objetivos comunes del proyecto.', ' ', 13, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T14 - Soluciones tecnológicas', 'Implementación adicional de soluciones tecnológicas para abordar desafíos específicos del proyecto. Comprende la aplicación de tecnologías adicionales para mejorar la funcionalidad y el rendimiento del proyecto.', ' ', 14, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T15 - Cierre del Proyecto', 'Finalización del proyecto, incluyendo la evaluación final, la documentación y la entrega del producto o servicio al cliente. Comprende la conclusión ordenada y efectiva de todas las actividades del proyecto.', ' ', 15, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('Final', 'Evaluación final que evaluará los conocimientos y habilidades adquiridos en todos los aspectos del proyecto. Demuestra tu capacidad para planificar, implementar y gestionar soluciones tecnológicas efectivas.', ' ', 16, '8a27a197-5bce-441f-887e-3e57b73eae1c', '83b7785f-6f65-11ee-ab19-0242ac110002'),


('T01 - Integración de aplicaciones', 'Explora las técnicas y tecnologías para integrar diversas aplicaciones en un entorno empresarial. Comprende los desafíos y mejores prácticas para lograr una integración efectiva y sin problemas.', ' ', 1, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T02 - Migración de aplicaciones', 'Aprende sobre las estrategias y herramientas necesarias para migrar aplicaciones legacy a plataformas modernas y eficientes. Comprende los procesos y consideraciones clave para una migración exitosa.', ' ', 2, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T03 - Integración web', 'Exploración de las tecnologías y estándares para integrar aplicaciones a través de interfaces web. Comprende los protocolos y métodos para lograr una integración efectiva en entornos web.', ' ', 3, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T04 - Integración de datos', 'Aprende sobre las técnicas y herramientas para integrar y transformar datos de diversas fuentes. Comprende los procesos de limpieza, transformación y carga para asegurar la calidad y coherencia de los datos integrados.', ' ', 4, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T05 - Integración en la nube', 'Exploración de las estrategias y tecnologías para lograr una integración efectiva en entornos de nube. Comprende los servicios y herramientas específicas para integrar aplicaciones y datos en plataformas de nube.', ' ', 5, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T06 - Automatización de procesos', 'Aprende sobre las técnicas y herramientas para automatizar procesos empresariales. Comprende la modelización, ejecución y monitorización de flujos de trabajo automatizados para mejorar la eficiencia operativa.', ' ', 6, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T07 - Optimización de procesos', 'Exploración de las estrategias para optimizar procesos empresariales integrados. Comprende el análisis de procesos, identificación de áreas de mejora y aplicación de soluciones para lograr eficiencia y calidad mejoradas.', ' ', 7, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('Parcial', 'Evaluación parcial para evaluar la comprensión de los conceptos y técnicas de integración aprendidos hasta ahora.', ' ', 8, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T09 - Gestión de la continuidad del negocio', 'Aprende sobre las estrategias y mejores prácticas para garantizar la continuidad del negocio en entornos integrados. Comprende la planificación, implementación y prueba de planes de continuidad para mitigar riesgos.', ' ', 9, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T10 - Seguridad en la integración', 'Exploración de las medidas y tecnologías para asegurar la seguridad en los procesos y datos integrados. Comprende los controles de seguridad, la autenticación y el cifrado para proteger la integridad y confidencialidad de la información.', ' ', 10, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T11 - Monitoreo y análisis', 'Aprende sobre las técnicas y herramientas para monitorear y analizar procesos integrados. Comprende la recopilación de datos, análisis de rendimiento y generación de informes para mejorar la visibilidad y toma de decisiones.', ' ', 11, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T12 - Mejora continua', 'Exploración de las estrategias para la mejora continua de los procesos integrados. Comprende la retroalimentación, análisis de resultados y ajuste constante para lograr procesos más eficientes y efectivos.', ' ', 12, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T13 - Gestión del cambio', 'Aprende sobre las técnicas para gestionar el cambio en entornos de integración. Comprende la planificación, comunicación y mitigación de resistencias para asegurar una transición suave durante los cambios en los procesos integrados.', ' ', 13, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T14 - Innovación en la integración', 'Exploración de las estrategias para fomentar la innovación en los procesos y tecnologías integrados. Comprende la identificación de oportunidades, experimentación y adopción de nuevas tecnologías para lograr procesos más eficientes y competitivos.', ' ', 14, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('T15 - Evaluación de tecnologías', 'Aprende sobre las técnicas para evaluar y seleccionar tecnologías de integración. Comprende la comparación de soluciones, evaluación de costos y beneficios, y toma de decisiones informada para seleccionar las tecnologías adecuadas.', ' ', 15, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002'),
('Final', 'Evaluación final que evaluará el conocimiento y las habilidades adquiridas en todos los aspectos de la integración de aplicaciones empresariales. Demuestra tu capacidad para planificar, implementar y gestionar procesos de integración efectivos.', ' ', 16, 'e8f84455-93ef-4583-921c-2f7f82ad42dd', '83b7785f-6f65-11ee-ab19-0242ac110002');


INSERT INTO class_students (id_classroom, id_student)
VALUES
('1a497a1b-67b9-11ee-ad27-0242ac110002', '082da7bb-ea0a-4365-be8f-f32d4013c725'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '0a9e8d54-f39f-4365-9921-76480490e92e'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '10b26fb3-7f1e-413c-97be-2af8d1ced4b9'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '11500591-f07e-4171-98f9-2c4b75454e03'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '1597db82-e40a-421e-864b-a99b541e8348'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '1ada31f2-5d15-4cfa-91a1-a9ec984ee859'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '1c995ab5-3e36-4bd5-bf9c-13a866d849d8'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '22dc64a6-e31a-4fd7-9d7b-500485f535a9'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '2896dbd6-d784-4ff5-86ae-5da1b2768d0c'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '2bcf601e-d34b-4f44-85c2-c301a02363fd'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '2cda6a81-2ff3-4e49-93cb-f1ccd48cf1af'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '2ce1bed7-3d30-456c-9985-6a96da971254'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '37008c62-df5e-4171-89c9-94b2e5d2154e'),
('1a497a1b-67b9-11ee-ad27-0242ac110002', '3c02a582-2453-4d98-aecb-b89bbc7c55a2');


INSERT INTO class_students (id_classroom, id_student)
VALUES
('5800b821-67b9-11ee-ad27-0242ac110002', '082da7bb-ea0a-4365-be8f-f32d4013c725'),
('5800b821-67b9-11ee-ad27-0242ac110002', '0a9e8d54-f39f-4365-9921-76480490e92e'),
('5800b821-67b9-11ee-ad27-0242ac110002', '10b26fb3-7f1e-413c-97be-2af8d1ced4b9'),
('5800b821-67b9-11ee-ad27-0242ac110002', '11500591-f07e-4171-98f9-2c4b75454e03'),
('5800b821-67b9-11ee-ad27-0242ac110002', '1597db82-e40a-421e-864b-a99b541e8348'),
('5800b821-67b9-11ee-ad27-0242ac110002', '1ada31f2-5d15-4cfa-91a1-a9ec984ee859'),
('5800b821-67b9-11ee-ad27-0242ac110002', '1c995ab5-3e36-4bd5-bf9c-13a866d849d8'),
('5800b821-67b9-11ee-ad27-0242ac110002', '22dc64a6-e31a-4fd7-9d7b-500485f535a9'),
('5800b821-67b9-11ee-ad27-0242ac110002', '2896dbd6-d784-4ff5-86ae-5da1b2768d0c'),
('5800b821-67b9-11ee-ad27-0242ac110002', '2bcf601e-d34b-4f44-85c2-c301a02363fd'),
('5800b821-67b9-11ee-ad27-0242ac110002', '2cda6a81-2ff3-4e49-93cb-f1ccd48cf1af'),
('5800b821-67b9-11ee-ad27-0242ac110002', '2ce1bed7-3d30-456c-9985-6a96da971254'),
('5800b821-67b9-11ee-ad27-0242ac110002', '37008c62-df5e-4171-89c9-94b2e5d2154e'),
('5800b821-67b9-11ee-ad27-0242ac110002', '3c02a582-2453-4d98-aecb-b89bbc7c55a2');


INSERT INTO groups_class (group_name)
VALUES
('G01 Dev App II'), ('G02 Dev App II'), ('G03 Dev App II'), ('G04 Dev App II'),
('G01 Dev Sol Cloud'), ('G02 Dev Sol Cloud'), ('G03 Dev Sol Cloud'), ('G04 Dev Sol Cloud'),
('G01 Com Escrita'), ('G02 Com Escrita'), ('G03 Com Escrita'), ('G04 Com Escrita'),
('G01 Seg y Cont Sis'), ('G02 Seg y Cont Sis'), ('G03 Seg y Cont Sis'), ('G04 Seg y Cont Sis'),
('G01 Analít Emp Sis Emp'), ('G02 Analít Emp Sis Emp'), ('G03 Analít Emp Sis Emp'), ('G04 Analít Emp Sis Emp'),
('G01 Ingles III'), ('G02 Ingles III'), ('G03 Ingles III'), ('G04 Ingles III'),
('G01 Ingles II'), ('G02 Ingles II'), ('G03 Ingles II'), ('G04 Ingles II'),
('G01 Anális Ent Neg'), ('G02 Anális Ent Neg'), ('G03 Anális Ent Neg'), ('G04 Anális Ent Neg'),
('G01 Dev App Móviles'), ('G02 Dev App Móviles'), ('G03 Dev App Móviles'), ('G04 Dev App Móviles'),
('G01 Intro a la Prog'), ('G02 Intro a la Prog'), ('G03 Intro a la Prog'), ('G04 Intro a la Prog'),
('G01 Dev App I'), ('G02 Dev App I'), ('G03 Dev App I'), ('G04 Dev App I'),
('G01 Mod Neg y Startups'), ('G02 Mod Neg y Startups'), ('G03 Mod Neg y Startups'), ('G04 Mod Neg y Startups'),
('G01 Fund de Mkt'), ('G02 Fund de Mkt'), ('G03 Fund de Mkt'), ('G04 Fund de Mkt'),
('G01 Apps Móviles iPhone'), ('G02 Apps Móviles iPhone'), ('G03 Apps Móviles iPhone'), ('G04 Apps Móviles iPhone'),
('G01 Comp Intrapersonales'), ('G02 Comp Intrapersonales'), ('G03 Comp Intrapersonales'), ('G04 Comp Intrapersonales'),
('G01 Cálculo Cien e Ing'), ('G02 Cálculo Cien e Ing'), ('G03 Cálculo Cien e Ing'), ('G04 Cálculo Cien e Ing'),
('G01 Prog Avan Base Datos'), ('G02 Prog Avan Base Datos'), ('G03 Prog Avan Base Datos'), ('G04 Prog Avan Base Datos'),
('G01 Prog Web II'), ('G02 Prog Web II'), ('G03 Prog Web II'), ('G04 Prog Web II'),
('G01 Desarrollo Resiliencia'), ('G02 Desarrollo Resiliencia'), ('G03 Desarrollo Resiliencia'), ('G04 Desarrollo Resiliencia'),
('G01 Anális y Diseño Sis II'), ('G02 Anális y Diseño Sis II'), ('G03 Anális y Diseño Sis II'), ('G04 Anális y Diseño Sis II'),
('G01 Diseño y Desarrollo Web'), ('G02 Diseño y Desarrollo Web'), ('G03 Diseño y Desarrollo Web'), ('G04 Diseño y Desarrollo Web'),
('G01 Gestión Proyectos'), ('G02 Gestión Proyectos'), ('G03 Gestión Proyectos'), ('G04 Gestión Proyectos'),
('G01 Diseño y Prog Base Datos'), ('G02 Diseño y Prog Base Datos'), ('G03 Diseño y Prog Base Datos'), ('G04 Diseño y Prog Base Datos'),
('G01 Ingles I'), ('G02 Ingles I'), ('G03 Ingles I'), ('G04 Ingles I'),
('G01 Dev App Emp II'), ('G02 Dev App Emp II'), ('G03 Dev App Emp II'), ('G04 Dev App Emp II'),
('G01 Proy Tecno'), ('G02 Proy Tecno'), ('G03 Proy Tecno'), ('G04 Proy Tecno'),
('G01 Mat Aplic Cosas'), ('G02 Mat Aplic Cosas'), ('G03 Mat Aplic Cosas'), ('G04 Mat Aplic Cosas'),
('G01 Gest Dispo Tecno'), ('G02 Gest Dispo Tecno'), ('G03 Gest Dispo Tecno'), ('G04 Gest Dispo Tecno'),
('G01 Dev App Emp I'), ('G02 Dev App Emp I'), ('G03 Dev App Emp I'), ('G04 Dev App Emp I'),
('G01 Apps Móviles Android'), ('G02 Apps Móviles Android'), ('G03 Apps Móviles Android'), ('G04 Apps Móviles Android'),
('G01 Alg y Estruc Datos'), ('G02 Alg y Estruc Datos'), ('G03 Alg y Estruc Datos'), ('G04 Alg y Estruc Datos'),
('G01 Anális y Diseño Sis I'), ('G02 Anális y Diseño Sis I'), ('G03 Anális y Diseño Sis I'), ('G04 Anális y Diseño Sis I'),
('G01 Soluc Bas Inter Cosas'), ('G02 Soluc Bas Inter Cosas'), ('G03 Soluc Bas Inter Cosas'), ('G04 Soluc Bas Inter Cosas'),
('G01 Calidad y Pruebas Soft'), ('G02 Calidad y Pruebas Soft'), ('G03 Calidad y Pruebas Soft'), ('G04 Calidad y Pruebas Soft'),
('G01 Integración Aplicaciones'), ('G02 Integración Aplicaciones'), ('G03 Integración Aplicaciones'), ('G04 Integración Aplicaciones'),
('G01 Direc Personas'), ('G02 Direc Personas'), ('G03 Direc Personas'), ('G04 Direc Personas'),
('G01 Prog Web I'), ('G02 Prog Web I'), ('G03 Prog Web I'), ('G04 Prog Web I'),
('G01 Ética Profesional'), ('G02 Ética Profesional'), ('G03 Ética Profesional'), ('G04 Ética Profesional');

-- Para el id_classroom: 01faefd5-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '01faefd5-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 07de7e31-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '07de7e31-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3 ;

-- Para el id_classroom: 0bffd540-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '0bffd540-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 0fe90147-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '0fe90147-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 15d8cf76-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '15d8cf76-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 1a497a1b-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '1a497a1b-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 1dcbc595-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '1dcbc595-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 219f08d8-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '219f08d8-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 249c4e1e-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '249c4e1e-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 2895bc3e-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '2895bc3e-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 2c5fa398-67b2-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '2c5fa398-67b2-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 2c6a5420-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '2c6a5420-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 3073975f-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '3073975f-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 30974fb2-67b2-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '30974fb2-67b2-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 33801e22-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '33801e22-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 3502ee35-67b2-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '3502ee35-67b2-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 37428f09-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '37428f09-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 3b69f861-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '3b69f861-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 40d76b2e-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '40d76b2e-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 459144aa-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '459144aa-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 48d62d28-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '48d62d28-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 4c683763-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '4c683763-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 502e3352-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '502e3352-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 54d54029-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '54d54029-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 5800b821-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '5800b821-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 5a43a8dd-67b2-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '5a43a8dd-67b2-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 5d1a9187-67b9-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '5d1a9187-67b9-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: 6ea3eaea-67b2-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT '6ea3eaea-67b2-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: d1730cb1-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'd1730cb1-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: d5314494-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'd5314494-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: d8180768-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'd8180768-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: dbe74fd5-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'dbe74fd5-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: e05a53b8-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'e05a53b8-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: eb857224-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'eb857224-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: efd9b81b-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'efd9b81b-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: f8fc44a1-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'f8fc44a1-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;

-- Para el id_classroom: fd1401a0-67b8-11ee-ad27-0242ac110002
INSERT IGNORE INTO class_students (id_classroom, id_student, registration_date)
SELECT 'fd1401a0-67b8-11ee-ad27-0242ac110002', id_user, NOW() FROM users where user_type = 3;


INSERT IGNORE INTO class_groups_students (id_classroom, id_student, id_group)
SELECT '01faefd5-67b9-11ee-ad27-0242ac110002', id_user, CEIL(RAND() * (4 - 1 + 1) + 1)
FROM users
WHERE user_type = 3;



SELECT * FROM classrooms;
select * from classroom_view;

CREATE VIEW user_profile AS
SELECT u.id_user, u.firstname, u.surnames, u.email, u.phone, u.photo,
       u.address, u.birthday, u.doc_id, c.title career
FROM users u LEFT JOIN careers c ON u.id_career = c.id_career;

DELIMITER //

CREATE PROCEDURE getProfile(IN id_user_ VARCHAR(36))
BEGIN
    SELECT u.id_user, u.firstname, u.surnames, u.email, u.phone, u.photo,
           u.address, u.birthday, u.doc_id, c.title as career
    FROM users u
    LEFT JOIN careers c ON u.id_career = c.id_career
    WHERE u.id_user = id_user_;
END//

DELIMITER ;

CALL getProfile('f97ad5f8-67b1-11ee-ad27-0242ac110002');

CREATE VIEW class_details_view AS
SELECT
    c.id_classroom,
    c.nrc,
    c.school_day,
    c.link_meet,
    c.total_hours,
    c.modality,
    c.campus,
    c.start_date,
    c.end_date,
    c.start_time,
    c.end_time,
    co.id_course,
    co.course_name,
    co.description,
    csd.id_user as id_student,
    u.id_user as id_teacher,
    u.firstname as teacher_firstname,
    u.surnames as teacher_surnames,
    csd.firstname as student_firstname,
    csd.surnames as student_surnames
FROM classrooms c
         INNER JOIN courses co ON c.id_course = co.id_course
         INNER JOIN users u ON c.id_teacher = u.id_user
         LEFT JOIN class_students cs ON c.id_classroom = cs.id_classroom
         LEFT JOIN users csd ON csd.id_user = cs.id_student;

CREATE VIEW course_view as
select
 co.id_course,
    co.course_name,
    co.credits,
    co.description,
    csd.id_user as id_student,
    co.syllabus
 FROM classrooms c
         INNER JOIN courses co ON c.id_course = co.id_course
         INNER JOIN users u ON c.id_teacher = u.id_user
         LEFT JOIN class_students cs ON c.id_classroom = cs.id_classroom
         LEFT JOIN users csd ON csd.id_user = cs.id_student;

CREATE VIEW members_class as
SELECT cs.id_student, cs.id_classroom, CONCAT(u.firstname, ', ', u.surnames) names, u.email, u.photo
FROM class_students cs
         INNER JOIN users u ON cs.id_student = u.id_user;

CREATE VIEW student_groups_classes AS
SELECT cs.id_student, cs.id_classroom, cs.id_group, gp.group_name, CONCAT(u.firstname, ', ', u.surnames) names, u.photo, u.email
FROM class_groups_students cs
        INNER JOIN users u ON cs.id_student = u.id_user
        INNER JOIN groups_class gp ON gp.id_group = cs.id_group;


UPDATE contents SET link_file = 'https://res.cloudinary.com/durrquwiy/image/upload/v1696636531/syllabus/30015-SILABO_tsaov5.pdf';
