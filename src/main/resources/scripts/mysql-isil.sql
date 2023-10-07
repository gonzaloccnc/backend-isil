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
	syllabus VARCHAR(200) NOT NULL
);

CREATE TABLE contents (
	id_content SMALLINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(150) NOT NULL,
	description TEXT NOT NULL,
	link_file VARCHAR(200) NOT NULL,
	num_order SMALLINT NOT NULL,
	id_course varchar(36) NOT NULL,
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
 period varchar(6) NOT NULL,
 start_date date NOT NULL,
 end_date date NOT NULL,
 max_members INT NOT NULL,
 id_teacher varchar(36) NOT NULL,
 id_course varchar(36) NOT NULL,
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

CREATE TABLE groups_evaluations (
	id_group varchar(36) not null primary key,
    upload_date datetime not null,
    link_file text,
    note decimal(3,1),
    state smallint,
    max_members smallint not null,
    check (note between 0 and 20)
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

INSERT INTO careers VALUES 
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

INSERT INTO courses
VALUES 
	('4bd14b81-e79e-445a-83eb-82980726eb26', 'Cálculo para Ciencias e Ingeniería', 3, 'El curso de "Cálculo para Ciencias e Ingeniería" es un enfoque integral que combina teoría y práctica para proporcionar a los estudiantes las habilidades necesarias en el ámbito del cálculo, con un enfoque específico en su aplicación en las ciencias y la ingeniería.', 'calculo-para-ciencias-e-ingenieria.pdf'),
	('1ad1366a-5cbb-4340-b45f-410f045b6b00', 'Comunicación Escrita', 2, 'El curso de "Comunicación Escrita" se enfoca en desarrollar las habilidades de redacción y comunicación efectiva en entornos académicos y profesionales. Los estudiantes aprenderán a expresar sus ideas de manera clara y coherente.', 'comunicacion-escrita.pdf'),
	('8b94a716-f4ee-4660-9cd8-61ffee8f9610', 'Matemática Aplicada de las Cosas', 3, 'El curso de "Matemática Aplicada de las Cosas" se centra en la aplicación de conceptos matemáticos en situaciones del mundo real, especialmente en el contexto de la tecnología y la ciencia.', 'matematica-aplicada-de-las-cosas.pdf'),
	('9135035c-0788-4d17-ace8-6f0546c497c3', 'Gestión de Dispositivos Tecnológicos', 4, 'Este curso aborda la gestión de dispositivos tecnológicos, incluyendo la planificación, implementación y mantenimiento de infraestructuras tecnológicas en empresas y organizaciones.', 'gestion-de-dispositivos-tecnologicos.pdf'),
	('1eaec303-4921-48cf-aeb1-cea54393125b', 'Seguridad y Continuidad de Sistemas', 3, 'El curso de "Seguridad y Continuidad de Sistemas" se enfoca en la protección de sistemas informáticos y la planificación para garantizar la continuidad de operaciones en situaciones adversas.', 'seguridad-y-continuidad-de-sistemas.pdf'),
	('5ec96936-63f7-4c16-aae5-82133b74befb', 'Gestión de Proyectos', 3, 'Este curso se centra en los principios y prácticas de gestión de proyectos, preparando a los estudiantes para liderar y ejecutar proyectos tecnológicos de manera efectiva.', 'gestion-de-proyectos.pdf'),
	('414a02de-d41f-4832-b142-8afb8eb32361', 'Fundamentos de Marketing', 2, 'Este curso introduce los conceptos fundamentales de marketing, incluyendo estrategias de mercado, segmentación de clientes y promoción de productos y servicios.', 'fundamentos-de-marketing.pdf'),
	('f5494257-ad5f-4962-95ae-19e4a1d15714', 'Ética Profesional', 2, 'Este curso explora cuestiones éticas en el campo de la tecnología y la ingeniería, preparando a los estudiantes para tomar decisiones éticas en su futura carrera profesional.', 'etica-profesional.pdf'),
	('491e39bc-0827-4a3d-9a44-179b6292cbd9', 'Competencias Intrapersonales', 2, 'El curso de "Competencias Intrapersonales" se centra en el desarrollo de habilidades personales y profesionales, como la autoevaluación, la comunicación efectiva y el trabajo en equipo.', 'competencias-intrapersonales.pdf'),
	('f932f948-d7d5-449a-8561-bc8e353bc330', 'Gestión de la Creatividad e Innovación', 3, 'Este curso explora el proceso de gestión de la creatividad y la innovación en el contexto empresarial y tecnológico, fomentando la generación de ideas innovadoras.', 'gestion-de-la-creatividad-e-innovacion.pdf'),
	('58143065-56d6-4c45-b9f0-8120bb11bcca', 'Desarrollo de Resiliencia', 2, 'El curso de "Desarrollo de Resiliencia" se enfoca en la capacidad de enfrentar desafíos y adversidades de manera efectiva, promoviendo la resiliencia en situaciones personales y profesionales.', 'desarrollo-de-resiliencia.pdf'),
	('eef7f963-daa9-4151-b770-c20a8271bdd3', 'Dirección de Personas', 3, 'Este curso aborda la gestión de recursos humanos y el liderazgo de equipos en entornos tecnológicos y empresariales.', 'direccion-de-personas.pdf'),
	('5df91abb-1655-49bb-8c13-186b2b1e3efc', 'Diseño y Desarrollo Web', 3, 'El curso de "Diseño y Desarrollo Web" se enfoca en la creación de sitios web efectivos, incluyendo aspectos de diseño visual, usabilidad y programación web.', 'diseno-y-desarrollo-web.pdf'),
	('c7e22a28-9688-409e-9995-dbe87ceca741', 'Soluciones Basadas en Internet de las Cosas', 4, 'El curso de "Soluciones Basadas en Internet de las Cosas" explora cómo crear soluciones tecnológicas utilizando dispositivos IoT y plataformas de conectividad.', 'soluciones-basadas-en-iot.pdf'),
	('3aa51a30-b3b2-47bd-a439-e41f1994e0a5', 'Introducción a la Programación', 2, 'Este curso es una introducción a los conceptos fundamentales de la programación, incluyendo algoritmos, estructuras de datos y lenguajes de programación.', 'introduccion-a-la-programacion.pdf'),
	('b0cc01be-aff3-48ee-9833-474821f5a479', 'Algoritmo y Estructuras de Datos', 3, 'El curso de "Algoritmo y Estructuras de Datos" profundiza en la comprensión de algoritmos eficientes y estructuras de datos utilizadas en el desarrollo de software.', 'algoritmo-y-estructuras-de-datos.pdf'),
	('606dbea8-a491-40df-b4d5-02697fa47218', 'Diseño y Programación de Base de Datos', 3, 'Este curso se enfoca en el diseño y programación de bases de datos, preparando a los estudiantes para crear sistemas de gestión de datos efectivos.', 'diseno-y-programacion-de-base-de-datos.pdf'),
	('b9cdf0e0-2184-43bf-87e5-2627b2c48688', 'Análisis y Diseño de Sistemas I', 3, 'El curso de "Análisis y Diseño de Sistemas I" se centra en los conceptos y metodologías para analizar y diseñar sistemas de software, incluyendo diagramas de flujo y requisitos del sistema.', 'analisis-y-diseno-de-sistemas-i.pdf'),
	('c8c7859f-da74-4986-9391-b9079043f9c1', 'Calidad y Pruebas de Software', 3, 'El curso de "Calidad y Pruebas de Software" se enfoca en la aseguramiento de la calidad del software y las estrategias de prueba para garantizar que las aplicaciones funcionen de manera eficiente y libre de errores.', 'calidad-y-pruebas-de-software.pdf'),
	('65310835-39a2-4e1e-8ef1-aedfe3933d9c', 'Inglés Extranjero I', 2, 'El curso de "Inglés Extranjero I" proporciona una introducción al idioma inglés, incluyendo gramática, vocabulario y conversación básica.', 'ingles-extranjero-i.pdf'),
	
	('3c2e7478-cd8c-49c7-884b-5bee2fd1c3d1', 'Desarrollo de Aplicaciones I', 3, 'El curso de "Desarrollo de Aplicaciones I" se enfoca en la creación de aplicaciones de software, incluyendo conceptos de diseño de software y programación orientada a objetos.', 'desarrollo-de-aplicaciones-i.pdf'),
	('35d0aede-0d3c-4140-bea9-809068bf96fe', 'Desarrollo de Aplicaciones Móviles', 3, 'Este curso se enfoca en el desarrollo de aplicaciones móviles para diversas plataformas y dispositivos, incluyendo aspectos de diseño y usabilidad.', 'desarrollo-de-aplicaciones-moviles.pdf'),
	('327e25f2-7097-45e7-b915-285493fd8c50', 'Análisis del Entorno de Negocios', 2, 'El curso de "Análisis del Entorno de Negocios" proporciona una comprensión de los factores externos que afectan a las organizaciones y cómo analizarlos para tomar decisiones informadas.', 'analisis-del-entorno-de-negocios.pdf'),
	('3f0a6854-9503-4ab7-8d72-e3cc425adca8', 'Modelos de Negocios y Startups', 3, 'El curso de "Modelos de Negocios y Startups" se enfoca en el desarrollo y análisis de modelos de negocios innovadores, con un énfasis en las startups tecnológicas.', 'modelos-de-negocios-y-startups.pdf'),
	('f53b7b20-2bcd-4592-8efd-6a1b30bb9b76', 'Programación Web I', 3, 'El curso de "Programación Web I" se centra en la introducción a las tecnologías y conceptos fundamentales para desarrollar aplicaciones web. Los estudiantes aprenderán sobre HTML, CSS y JavaScript.', 'programacion-web-i.pdf'),
	('9f84abcb-0246-4a3f-8993-eaa621b44dc5', 'Desarrollo de Aplicaciones Empresariales I', 3, 'El curso de "Desarrollo de Aplicaciones Empresariales I" se centra en la creación de soluciones de software para empresas, incluyendo sistemas empresariales y bases de datos.', 'desarrollo-de-aplicaciones-empresariales-i.pdf'),
	('2642af00-6ea9-4df6-9c1b-1dd94091ed33', 'Inglés Extranjero II', 2, 'Este curso es una continuación de "Inglés Extranjero I" y se enfoca en el desarrollo de habilidades de comunicación en inglés en situaciones cotidianas.', 'ingles-extranjero-ii.pdf'),
	
	('56b2dcd6-9e3d-4d44-9b54-daa55c4ce3a4', 'Programación Web II', 3, 'Este curso es una continuación de "Programación Web I" y profundiza en el desarrollo de aplicaciones web dinámicas utilizando tecnologías avanzadas como frameworks de JavaScript y backend.', 'programacion-web-ii.pdf'),
	('0a5bdac3-ca52-441a-bc2a-b6fd141de409', 'Desarrollo de Aplicaciones II', 3, 'Este curso es una continuación de "Desarrollo de Aplicaciones I" y se adentra en aspectos más avanzados del desarrollo de aplicaciones, incluyendo bases de datos y diseño de interfaces de usuario.', 'desarrollo-de-aplicaciones-ii.pdf'),
	('a23e57ea-529d-410e-841d-290a2862ec03', 'Aplicaciones Móviles para Android', 3, 'El curso de "Aplicaciones Móviles para Android" se enfoca en el desarrollo de aplicaciones para dispositivos Android utilizando lenguajes y herramientas específicas.', 'aplicaciones-moviles-para-android.pdf'),	
	('415d6fcd-3292-4ff5-bb3f-82f67a5d9033', 'Aplicaciones Móviles para iPhone', 3, 'Este curso aborda el desarrollo de aplicaciones móviles para dispositivos iPhone y iOS, incluyendo el uso de Swift y herramientas de desarrollo de Apple.', 'aplicaciones-moviles-para-iphone.pdf'),
	('695c02d3-2cda-4e70-9b3e-6ddc5c0bc8a4', 'Desarrollo de Aplicaciones Empresariales II', 3, 'Este curso es una continuación de "Desarrollo de Aplicaciones Empresariales I" y profundiza en el desarrollo de sistemas empresariales y soluciones tecnológicas avanzadas.', 'desarrollo-de-aplicaciones-empresariales-ii.pdf'),
	('e8f84455-93ef-4583-921c-2f7f82ad42dd', 'Integración de Aplicaciones', 3, 'El curso de "Integración de Aplicaciones" explora cómo integrar sistemas y aplicaciones tecnológicas en entornos empresariales, garantizando la interoperabilidad.', 'integracion-de-aplicaciones.pdf'),
	('0ae79e89-7324-4de7-a1d5-73d9fec44e96', 'Desarrollo de Soluciones Cloud', 3, 'Este curso se enfoca en el desarrollo de aplicaciones y soluciones basadas en la nube, aprovechando plataformas y servicios en la nube.', 'desarrollo-de-soluciones-cloud.pdf'),
	('8a27a197-5bce-441f-887e-3e57b73eae1c', 'Proyecto Tecnológico', 4, 'El curso de "Proyecto Tecnológico" tiene como objetivo guiar a los estudiantes a través del proceso de formulación y ejecución de proyectos tecnológicos en entornos empresariales.', 'proyecto-tecnologico.pdf'),
	('4f71edc9-6c89-4812-81cf-8b5477c8541e', 'Programación Avanzada de Base de Datos', 3, 'El curso de "Programación Avanzada de Base de Datos" profundiza en el diseño y programación de bases de datos complejas, incluyendo optimización y seguridad.', 'programacion-avanzada-de-base-de-datos.pdf'),
	('5857f1fe-1a12-4f97-80fc-2e31af5d695c', 'Análisis y Diseño de Sistemas II', 3, 'Este curso es una continuación de "Análisis y Diseño de Sistemas I" y profundiza en las técnicas avanzadas de análisis y diseño de sistemas de software.', 'analisis-y-diseno-de-sistemas-ii.pdf'),
	('20ad25e5-2ef1-4b57-9da4-23c7f0f59cd9', 'Inglés Extranjero III', 2, 'El curso de "Inglés Extranjero III" avanza en las habilidades de inglés, incluyendo comprensión auditiva y expresión oral y escrita.', 'ingles-extranjero-iii.pdf'),
	
	('1fd08d7a-5395-4c1b-b3f1-81ff463ab64d', 'Analítica de Sistemas Empresariales', 3, 'Este curso explora el análisis de sistemas empresariales, incluyendo la recopilación y análisis de datos para mejorar la toma de decisiones en las organizaciones.', 'analitica-de-sistemas-empresariales.pdf');

/* admin */
INSERT INTO users values (uuid(), 'Manuel', 'Peña Lopez', '1885-05-24', 'Av los admins', '99412243', 0, 'admin123', 'admin@isil.pe', null, now(), 0, 1, null, null);

/* profesor  al menos 10 */
## INSERT INTO users values (uuid(), '', '');

/* constraseña hasheada para spring boot == isil20203, para todos los alumnos */
update users set password = "$2a$10$YmI8mkcnKEAhQKnot.gGgOFUHRAeKwy10iHm00MVS14Q2aqHTB6FC" where user_type = 3;

/* igual pero para el admin === admin123 */
update users set password = "$2a$10$BOm6GwouvlF88FLq7auaIO9BzbUCtcDMfZ/zU9o2IyqAJ4x.Pb0ZC" where email = "admin@isil.pe";

SELECT * FROM courses;
SELECT * FROM careers;
SELECT * FROM users where user_type = 1; -- admins

/* profesores */
INSERT INTO users (id_user, firstname, surnames, birthday, address, type_doc, doc_id, password, email, phone, id_career, register_date, state, photo, user_type)
VALUES
    ('6b32c6e3-6489-11ee-95e8-0242ac110002', 'Maria Maria', 'Becerra Garcia', '1995-10-03', 'Avenida Petit Thoars 5532', 0, '88332231', 'isil20203', 'becerra@gmail.com', '998877111', null, NOW(), 0, null, 2);


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

select * from classroom_view;

UPDATE courses SET syllabus = 'https://res.cloudinary.com/durrquwiy/image/upload/v1696636531/syllabus/30015-SILABO_tsaov5.pdf';