
drop table migration;
create table migration(
	id SERIAL,
  migration_name varchar(100) NOT NULL,
  source_device varchar(100) NOT NULL,
  destination_device varchar(100) NOT NULL,
  migration_status varchar(100) NOT NULL,
	migration_type varchar(100) NOT NULL,
  site varchar(100) NOT NULL,
  created_date timestamp  DEFAULT CURRENT_TIMESTAMP,
  created_by varchar(100) not null,
  modified_date timestamp   DEFAULT CURRENT_TIMESTAMP,
  modified_by varchar(100) not null,
	PRIMARY KEY (id)
);

drop table port_mapping;
CREATE TYPE port AS ENUM ('L2', 'L3');
create table port_mapping(
  id SERIAL,
  site varchar(50) NOT NULL,
  source_device varchar(50) NOT NULL,
  source_port_type bigint not null,
  destination_device varchar(256) not null,
  destination_port_type port not null,
  source_port varchar(50) not null,
  destination_port varchar(100) not null,
  created_date timestamp  DEFAULT CURRENT_TIMESTAMP,
  created_by varchar(100)  not null,
  modified_date timestamp   DEFAULT CURRENT_TIMESTAMP,
  modified_by varchar(100)  not null,
  PRIMARY KEY (id)
);

drop table migration_type;
CREATE TABLE migration_type (
  id SERIAL,
  name varchar(50) NOT NULL,
  description varchar(128),
  created_date timestamp  DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
  );

drop table migration_type_template;
CREATE TABLE migration_type_template (
  id SERIAL,
  migration_type_id bigint NOT NULL,
  migration_step varchar(150) NOT NULL,
  template_name text NOT NULL,
  form_component_name varchar(100)  DEFAULT NULL,
  created_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (template_name)
);

drop TABLE migration_process;
CREATE TABLE migration_process (
  id SERIAL,
  process_id varchar(100) NOT NULL,
  migration_id varchar(100) NOT NULL,
  current_state varchar(200) NOT NULL,
  created_by varchar(100)  DEFAULT NULL,
  created_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by varchar(100)  DEFAULT NULL,
  updated_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (id)
);


drop TABLE migration_state;
CREATE TABLE migration_state (
  id SERIAL,
  migration_process_id varchar(100) NOT NULL,
  task_id varchar(100) NOT NULL,
  execution_id varchar(200) NOT NULL,
  task_name varchar(200) NOT NULL,
  task_details varchar(200) NOT NULL,
  form_name varchar(200) NOT NULL,
  status varchar(200) NOT NULL,
  created_by varchar(100)  DEFAULT NULL,
  created_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

