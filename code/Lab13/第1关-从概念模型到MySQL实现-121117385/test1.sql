 # 请将你实现flight_booking数据库的语句写在下方：
drop database if exists flight_booking;
create database flight_booking;
use flight_booking;

drop table if exists `user`;
create table `user`(
    user_id int primary key auto_increment,
    firstname varchar(50) not null,
    lastname varchar(50) not null,
    dob date not null,
    sex char(1) not null,
    email varchar(50),
    phone varchar(30),
    username varchar(20) not null unique,
    `password` char(32) not null,
    admin_tag tinyint default 0 not null
);

drop table if exists passenger;
create table passenger(
    passenger_id int auto_increment primary key,
    id char(18) not null unique,
    firstname varchar(50) not null,
    lastname varchar(50) not null,
    mail varchar(50),
    phone varchar(20) not null,
    sex char(1) not null,
    dob date
);

drop table if exists airport;
create table airport(
    airport_id int auto_increment primary key,
    iata char(3) not null unique,
    icao char(4) not null unique,
    # 普通索引？
    name varchar(50) not null,
    city varchar(50),
    country varchar(50),
    latitude decimal(11, 8),
    longitude decimal(11, 8)
);
create index idx_name on airport(name);

drop table if exists airline;
create table airline(
    airline_id int auto_increment primary key,
    name varchar(30) not null,
    iata char(2) not null unique,
    airport_id int not null,
    constraint FK_airline_airport_id foreign key(airport_id) references airport(airport_id)
);

drop table if exists airplane;
create table airplane(
    airplane_id int auto_increment primary key,
    type varchar(50) not null,
    capacity smallint not null,
    identifier varchar(50) not null,
    airline_id int not null,
    constraint FK_airplane_airline_id foreign key(airline_id) references airline(airline_id)
);

drop table if exists flightschedule;
create table flightschedule(
    flight_no char(8) primary key,
    departure time not null,
    arrival time not null,
    duration smallint not null,
    monday tinyint default 0,
    tuesday tinyint default 0,
    wednesday tinyint default 0,
    thursday tinyint default 0,
    friday tinyint default 0,
    saturday tinyint default 0,
    sunday tinyint default 0,
    airline_id int not null,
    `from` int not null,
    `to` int not null,
    constraint FK_flightschedule_airline_id foreign key(airline_id) references airline(airline_id),
    constraint FK_flightschedule_from foreign key(`from`) references airport(airport_id),
    constraint FK_flightschedule_to foreign key(`to`) references airport(airport_id)
);

drop table if exists flight;
create table flight(
    flight_id int auto_increment primary key,
    departure datetime not null,
    arrival datetime not null,
    duration smallint not null,
    airline_id int not null,
    airplane_id int not null,
    `from` int not null,
    `to` int not null,
    flight_no char(8) not null,
    constraint FK_flight_airline_id foreign key(airline_id) references airline(airline_id),
    constraint FK_flight_airplane_id foreign key(airplane_id) references airplane(airplane_id),
    constraint FK_flight_from foreign key(`from`) references airport(airport_id),
    constraint FK_flight_to foreign key(`to`) references airport(airport_id),
    constraint FK_flight_flight_no foreign key(flight_no) references flightschedule(flight_no)
);

drop table if exists ticket;
create table ticket(
    ticket_id int auto_increment primary key,
    seat char(4),
    price decimal(10, 2) not null,
    flight_id int not null,
    user_id int not null,
    passenger_id int not null,
    constraint FK_ticket_flight_id foreign key(flight_id) references flight(flight_id),
    constraint FK_ticket_user_id foreign key(user_id) references `user`(user_id),
    constraint FK_ticket_passenger_id foreign key(passenger_id) references passenger(passenger_id)
);