-- criação de banco de dados para o cenário de e-commerce

create database ecommerce;

use ecommerce;

-- cria tabela cliente

create table clients(
	idClient int auto_increment primary key,
    Fname varchar(15),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(50),
    constraint unique_cpf_client unique (CPF)
       
);
-- Altera as propriedades de Address
alter table clients modify column Address varchar(60);



-- cria tabela produto
-- size = dimensão do produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    category enum('Eletrônico','Vestuário','Brinquedos','Alimentos','Móveis') not null,
    avaliacao float default 0,
    size varchar(10)    

);
-- altera a coluna Pname
alter table product modify column Pname varchar(30);

-- cria tabela pagamento
-- terminar a tabela e criar conexão com as tabelas necessárias
-- criar constraint relacionadas ao pagamento
-- tabela não criada
create table payments(
	idClient int,
	id_payment int,
    typePayment enum('Dinheiro','Bolote','Cartão','Pix','Dois cartões') default 'Boleto',
    limitAvailable float,
    primary key (idClient, id_payment)
);

-- cria tabela pedido

create table orders (
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum ('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    -- idPayment ,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
		on update cascade
        
);



-- cria tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
    
);

-- cria tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar (255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- cria tabela vendedor
create table seller (
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbsName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
	contact char(11) not null,
    constraint unique_cnpf_seller unique (CNPJ),
    constraint unique_cpf_seller unique(CPF)
    
);

-- cria produtos - vendedor
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int not null,
    primary key(idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPSeller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);


-- cria tabela de ordem de pedidos
create table productOrder (
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productOrder_seller foreign key (idPOproduct) references product (idProduct),
    constraint fk_productOrder_product foreign key (idPOorder) references orders(idOrder)
	
);

-- tabela estoque
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);


create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);


-- inserindo informações
use ecommerce;
insert into Clients (Fname, Minit, Lname, CPF, Address)
	values('Maria','M','Silva',123456789,'Rua Silva da Patra 29, Carangola - Cidade das Flores'),
		('Matheus','O','Pimentel', 987654321,'Rua Alameda 289, Centro - Cidade das Flores'),
        ('Ricardo','F','Silva',45678913,'Avenida Alameda Vinha 1009, Centro - Cidade das Flores'),
        ('Julia','S','França',789123456,'Rua Laranjeiras 861, Centro - Cidade das Flores'),
        ('Roberta','G','Assis',98745631,'Avenida Koller 19, Centro - Cidade das Flores'),
        ('Isabela','M','Cruz',654789123,'Rua Alameda das Flores 28, Centro - Cidade das Flores');

-- idProduct, Pname, classification_kids boolean, category ('Eletrônico', 'Vestuário','Brinquedos','Alimentos','Móveis'), avaliação, size

insert into product(Pname, classification_kids, category, avaliacao, size) values
	('Fone de ouvido', false,'Eletrônico','4',null),
    ('Barbie',true,'Brinquedos','3',null),
    ('Body carters', true, 'Vestuário','5',null),
    ('Microfone Vedo- Youtuber',false,'Eletrônico','4', null ),
    ('Sofá retrátil', false, 'Móveis','3','3x57x80'),
    ('Farinha de arroz',false,'Alimentos','2',null),
    ('Fire Stick Amazon',false,'Eletrônico','3',null);
    
-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash

insert into orders (idOrder, orderStatus, orderDescription, sendValue, paymentCash) values
	(1,null, 'compra via aplicativo',null, 1),
    (2,null, 'compra via aplicativo',50,0),
    (3, 'Confirmado',null, null, 1),
    (4, null, 'Compra via web site',150, 0);

-- idPOproduct, idPOorder, poQuantity, poStatus
insert into productOrder (idPOproduct, idPOorder,poQuantity, poStatus) values
	(8,1,2,null),
    (9,1,1,null),
    (10,2,1,null);
    
select * from product;    

-- storageLocation, quantity
insert into productStorage(storageLocation, quantity) values
	('Rio de Janeiro',1000),
    ('Rio de Janeiro',500),
    ('São Paulo',10),
    ('São Paulo',100),
    ('São Paulo',10),
    ('Brasília',60);
    
-- idLProduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
	(8,2,'RJ'),
    (9,6,'GO');
    
-- idSupplier, SocialName, CNPJ, contact
insert into supplier(socialname, cnpj, contact) values
	('Almeida e Filhos', 123456789123456,'21985474'),
    ('Eletrônicos Silva',85451969143457,'21985484'),
    ('Eletrônicos Valma',934567893934695,'21975474');
    
-- idPSsupplier, idPSproduct, quantity    
insert into productSupplier (idPSsupplier, idPSproduct, quantity) values
	(1,8,500),
    (1,9,400),
    (2,11,633),
    (3,10,5),
    (2,12,10);
    
select * from product;    

-- inserindo informações na tabela 
insert into seller (socialname, absname, cnpj, cpf, location, contact) values
	('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro',219946287),
    ('Botique Durgar', null, null, 123456783, 'Rio de Janeiro',219567895),
    ('Kids World', null, 456789123654487, null, 'São Paulo', 1198657484);
select *from seller;

insert into productSeller (idPseller, idPproduct, prodQuantity) values
	(1,8,80),
    (2,9,10);

select * from productseller;

select count(*) from clients;
    
select * from clients c, orders o where c.idclient = idOrderclient;    