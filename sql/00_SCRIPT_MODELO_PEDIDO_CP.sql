DROP TABLE cp_movimento_estoque CASCADE CONSTRAINTS;

CREATE TABLE cp_movimento_estoque (
       SEQ_MOVIMENTO_ESTOQUE NUMBER(15) NOT NULL,
       COD_PRODUTO          NUMBER(10) NULL,
       DAT_MOVIMENTO_ESTOQUE DATE NULL,
       QTD_MOVIMENTACAO_ESTOQUE INTEGER NULL,
       COD_TIPO_MOVIMENTO_ESTOQUE NUMBER(2) NULL
);

CREATE UNIQUE INDEX cp_XPKmovimento_estoque ON cp_movimento_estoque
(
       SEQ_MOVIMENTO_ESTOQUE          ASC
);

CREATE INDEX cp_XIF1movimento_estoque ON cp_movimento_estoque
(
       COD_PRODUTO                    ASC
);

CREATE INDEX cp_XIF2movimento_estoque ON cp_movimento_estoque
(
       COD_TIPO_MOVIMENTO_ESTOQUE     ASC
);


ALTER TABLE cp_movimento_estoque
       ADD CONSTRAINT cp_XPKmovimento_estoque PRIMARY KEY (
              SEQ_MOVIMENTO_ESTOQUE);


DROP TABLE cp_produto_composto CASCADE CONSTRAINTS;

CREATE TABLE cp_produto_composto (
       COD_PRODUTO_RELACIONADO NUMBER(10) NOT NULL,
       COD_PRODUTO          NUMBER(10) NOT NULL,
       QTD_PRODUTO          NUMBER(6) NULL,
       QTD_PRODUTO_RELACIONADO NUMBER(6) NULL,
       STA_ATIVO            CHAR(1) NULL,
       DAT_CADASTRO         DATE NULL,
       DAT_CANCELAMENTO     DATE NULL
);

CREATE UNIQUE INDEX cp_XPKproduto_composto ON cp_produto_composto
(
       COD_PRODUTO_RELACIONADO        ASC,
       COD_PRODUTO                    ASC
);

CREATE INDEX cp_XIF1produto_composto ON cp_produto_composto
(
       COD_PRODUTO                    ASC
);

CREATE INDEX cp_XIF2produto_composto ON cp_produto_composto
(
       COD_PRODUTO_RELACIONADO        ASC
);


ALTER TABLE cp_produto_composto
       ADD CONSTRAINT cp_XPKproduto_composto PRIMARY KEY (
              COD_PRODUTO_RELACIONADO, COD_PRODUTO);


DROP TABLE cp_historico_pedido CASCADE CONSTRAINTS;

CREATE TABLE cp_historico_pedido (
       SEQ_HISTORICO_PEDIDO INTEGER NOT NULL,
       COD_PEDIDO           NUMBER(10) NOT NULL,
       COD_CLIENTE          NUMBER(10) NULL,
       DAT_PEDIDO           DATE NULL,
       DAT_CANCELAMENTO     DATE NULL,
       DAT_ENTREGA          DATE NULL,
       VAL_TOTAL_PEDIDO     NUMBER(12,2) NULL,
       VAL_DESCONTO         NUMBER(12,2) NULL,
       SEQ_ENDERECO_CLIENTE NUMBER(10) NULL,
       COD_VENDEDOR         NUMBER(4) NULL
);

CREATE UNIQUE INDEX cp_XPKhistorico_pedido ON cp_historico_pedido
(
       SEQ_HISTORICO_PEDIDO           ASC
);

CREATE INDEX cp_XIF1historico_pedido ON cp_historico_pedido
(
       SEQ_ENDERECO_CLIENTE           ASC
);

CREATE INDEX cp_XIF2historico_pedido ON cp_historico_pedido
(
       COD_CLIENTE                    ASC
);

CREATE INDEX cp_XIF4historico_pedido ON cp_historico_pedido
(
       COD_PEDIDO                     ASC
);

CREATE INDEX cp_XIF5historico_pedido ON cp_historico_pedido
(
       COD_VENDEDOR                   ASC
);


ALTER TABLE cp_historico_pedido
       ADD CONSTRAINT cp_XPKhistorico_pedido PRIMARY KEY (
              SEQ_HISTORICO_PEDIDO);


DROP TABLE cp_item_pedido CASCADE CONSTRAINTS;

CREATE TABLE cp_item_pedido (
       COD_PEDIDO           NUMBER(10) NOT NULL,
       COD_ITEM_PEDIDO      INTEGER NOT NULL,
       COD_PRODUTO          NUMBER(10) NULL,
       QTD_ITEM             NUMBER(10) NULL,
       VAL_UNITARIO_ITEM    NUMBER(12,2) NULL,
       VAL_DESCONTO_ITEM    NUMBER(12,2) NULL
);

CREATE UNIQUE INDEX cp_XPKitem_pedido ON cp_item_pedido
(
       COD_PEDIDO                     ASC,
       COD_ITEM_PEDIDO                ASC
);

CREATE INDEX cp_XIF1item_pedido ON cp_item_pedido
(
       COD_PEDIDO                     ASC
);

CREATE INDEX cp_XIF2item_pedido ON cp_item_pedido
(
       COD_PRODUTO                    ASC
);


ALTER TABLE cp_item_pedido
       ADD CONSTRAINT cp_XPKitem_pedido PRIMARY KEY (COD_PEDIDO, 
              COD_ITEM_PEDIDO);


DROP TABLE cp_pedido CASCADE CONSTRAINTS;

CREATE TABLE cp_pedido (
       COD_PEDIDO           NUMBER(10) NOT NULL,
       COD_PEDIDO_RELACIONADO NUMBER(10) NULL,
       COD_CLIENTE          NUMBER(10) NULL,
       COD_USUARIO          NUMBER(5) NULL,
       COD_VENDEDOR         NUMBER(4) NULL,
       DAT_PEDIDO           DATE NULL,
       DAT_CANCELAMENTO     DATE NULL,
       DAT_ENTREGA          DATE NULL,
       VAL_TOTAL_PEDIDO     NUMBER(12,2) NULL,
       VAL_DESCONTO         NUMBER(12,2) NULL,
       SEQ_ENDERECO_CLIENTE NUMBER(10) NULL
);

CREATE UNIQUE INDEX cp_XPKpedido ON cp_pedido
(
       COD_PEDIDO                     ASC
);

CREATE INDEX cp_XIF1pedido ON cp_pedido
(
       COD_CLIENTE                    ASC
);

CREATE INDEX cp_XIF2pedido ON cp_pedido
(
       SEQ_ENDERECO_CLIENTE           ASC
);

CREATE INDEX cp_XIF3pedido ON cp_pedido
(
       COD_PEDIDO_RELACIONADO         ASC
);

CREATE INDEX cp_XIF4pedido ON cp_pedido
(
       COD_VENDEDOR                   ASC
);

CREATE INDEX cp_XIF5pedido ON cp_pedido
(
       COD_USUARIO                    ASC
);


ALTER TABLE cp_pedido
       ADD CONSTRAINT cp_XPKpedido PRIMARY KEY (COD_PEDIDO);


DROP TABLE cp_usuario CASCADE CONSTRAINTS;

CREATE TABLE cp_usuario (
       COD_USUARIO          NUMBER(5) NOT NULL,
       NOM_USUARIO          VARCHAR2(50) NULL,
       STA_ATIVO            CHAR(1) NULL
);

CREATE UNIQUE INDEX cp_XPKusuario ON cp_usuario
(
       COD_USUARIO                    ASC
);


ALTER TABLE cp_usuario
       ADD CONSTRAINT cp_XPKusuario PRIMARY KEY (COD_USUARIO);


DROP TABLE cp_cliente_vendedor CASCADE CONSTRAINTS;

CREATE TABLE cp_cliente_vendedor (
       COD_CLIENTE          NUMBER(10) NOT NULL,
       COD_VENDEDOR         NUMBER(4) NOT NULL,
       DAT_INICIO           DATE NOT NULL,
       DAT_TERMINO          DATE NULL
);

CREATE UNIQUE INDEX cp_XPKcliente_vendedor ON cp_cliente_vendedor
(
       COD_CLIENTE                    ASC,
       COD_VENDEDOR                   ASC,
       DAT_INICIO                     ASC
);

CREATE INDEX cp_XIF1cliente_vendedor ON cp_cliente_vendedor
(
       COD_CLIENTE                    ASC
);

CREATE INDEX cp_XIF2cliente_vendedor ON cp_cliente_vendedor
(
       COD_VENDEDOR                   ASC
);


ALTER TABLE cp_cliente_vendedor
       ADD CONSTRAINT cp_XPKcliente_vendedor PRIMARY KEY (COD_CLIENTE, 
              COD_VENDEDOR, DAT_INICIO);


DROP TABLE cp_vendedor CASCADE CONSTRAINTS;

CREATE TABLE cp_vendedor (
       COD_VENDEDOR         NUMBER(4) NOT NULL,
       NOM_VENDEDOR         VARCHAR2(50) NULL,
       STA_ATIVO            CHAR(1) NULL
);

CREATE UNIQUE INDEX cp_XPKvendedor ON cp_vendedor
(
       COD_VENDEDOR                   ASC
);


ALTER TABLE cp_vendedor
       ADD CONSTRAINT cp_XPKvendedor PRIMARY KEY (COD_VENDEDOR);


DROP TABLE cp_endereco_cliente CASCADE CONSTRAINTS;

CREATE TABLE cp_endereco_cliente (
       SEQ_ENDERECO_CLIENTE NUMBER(10) NOT NULL,
       COD_TIPO_ENDERECO    NUMBER(2) NULL,
       COD_CLIENTE          NUMBER(10) NULL,
       DES_ENDERECO         VARCHAR2(80) NULL,
       NUM_ENDERECO         VARCHAR2(10) NULL,
       DES_COMPLEMENTO      VARCHAR2(20) NULL,
       NUM_CEP              NUMBER(9) NULL,
       DES_BAIRRO           VARCHAR2(50) NULL,
       COD_CIDADE           NUMBER(6) NULL,
       STA_ATIVO            CHAR(1) NULL,
       DAT_CADASTRO         DATE NULL,
       DAT_CANCELAMENTO     VARCHAR2(20) NULL
);

CREATE UNIQUE INDEX cp_XPKendereco_cliente ON cp_endereco_cliente
(
       SEQ_ENDERECO_CLIENTE           ASC
);

CREATE INDEX cp_XIF1endereco_cliente ON cp_endereco_cliente
(
       COD_CLIENTE                    ASC
);

CREATE INDEX cp_XIF2endereco_cliente ON cp_endereco_cliente
(
       COD_TIPO_ENDERECO              ASC
);

CREATE INDEX cp_XIF3endereco_cliente ON cp_endereco_cliente
(
       COD_CIDADE                     ASC
);


ALTER TABLE cp_endereco_cliente
       ADD CONSTRAINT cp_XPKendereco_cliente PRIMARY KEY (
              SEQ_ENDERECO_CLIENTE);


DROP TABLE cp_tipo_endereco CASCADE CONSTRAINTS;

CREATE TABLE cp_tipo_endereco (
       COD_TIPO_ENDERECO    NUMBER(2) NOT NULL,
       DES_TIPO_ENDERECO    VARCHAR2(50) NULL
);

CREATE UNIQUE INDEX cp_XPKtipo_endereco ON cp_tipo_endereco
(
       COD_TIPO_ENDERECO              ASC
);


ALTER TABLE cp_tipo_endereco
       ADD CONSTRAINT cp_XPKtipo_endereco PRIMARY KEY (COD_TIPO_ENDERECO);


DROP TABLE cp_estoque_produto CASCADE CONSTRAINTS;

CREATE TABLE cp_estoque_produto (
       COD_PRODUTO          NUMBER(10) NOT NULL,
       COD_ESTOQUE          NUMBER(4) NOT NULL,
       DAT_ESTOQUE          DATE NOT NULL,
       QTD_PRODUTO          NUMBER(10) NULL
);

CREATE UNIQUE INDEX cp_XPKestoque_produto ON cp_estoque_produto
(
       COD_PRODUTO                    ASC,
       COD_ESTOQUE                    ASC,
       DAT_ESTOQUE                    ASC
);

CREATE INDEX cp_XIF1estoque_produto ON cp_estoque_produto
(
       COD_PRODUTO                    ASC
);

CREATE INDEX cp_XIF2estoque_produto ON cp_estoque_produto
(
       COD_ESTOQUE                    ASC
);


ALTER TABLE cp_estoque_produto
       ADD CONSTRAINT cp_XPKestoque_produto PRIMARY KEY (COD_PRODUTO, 
              COD_ESTOQUE, DAT_ESTOQUE);


DROP TABLE cp_produto CASCADE CONSTRAINTS;

CREATE TABLE cp_produto (
       COD_PRODUTO          NUMBER(10) NOT NULL,
       NOM_PRODUTO          VARCHAR2(20) NULL,
       COD_BARRA            VARCHAR2(20) NULL,
       STA_ATIVO            VARCHAR2(20) NULL,
       DAT_CADASTRO         DATE NULL,
       DAT_CANCELAMENTO     DATE NULL
);

CREATE UNIQUE INDEX cp_XPKproduto ON cp_produto
(
       COD_PRODUTO                    ASC
);


ALTER TABLE cp_produto
       ADD CONSTRAINT cp_XPKproduto PRIMARY KEY (COD_PRODUTO);


DROP TABLE cp_cliente CASCADE CONSTRAINTS;

CREATE TABLE cp_cliente (
       COD_CLIENTE          NUMBER(10) NOT NULL,
       NOM_CLIENTE          VARCHAR2(50) NULL,
       DES_RAZAO_SOCIAL     VARCHAR2(80) NULL,
       TIP_PESSOA           CHAR(1) NULL,
       NUM_CPF_CNPJ         NUMBER(15) NULL,
       DAT_CADASTRO         DATE NULL,
       DAT_CANCELAMENTO     DATE NULL,
       STA_ATIVO            CHAR(1) NULL
);

CREATE UNIQUE INDEX cp_XPKcliente ON cp_cliente
(
       COD_CLIENTE                    ASC
);


ALTER TABLE cp_cliente
       ADD CONSTRAINT cp_XPKcliente PRIMARY KEY (COD_CLIENTE);


DROP TABLE cp_estoque CASCADE CONSTRAINTS;

CREATE TABLE cp_estoque (
       COD_ESTOQUE          NUMBER(4) NOT NULL,
       NOM_ESTOQUE          VARCHAR2(50) NULL
);

CREATE UNIQUE INDEX cp_XPKestoque ON cp_estoque
(
       COD_ESTOQUE                    ASC
);


ALTER TABLE cp_estoque
       ADD CONSTRAINT cp_XPKestoque PRIMARY KEY (COD_ESTOQUE);


DROP TABLE cp_cidade CASCADE CONSTRAINTS;

CREATE TABLE cp_cidade (
       COD_CIDADE           NUMBER(6) NOT NULL,
       NOM_CIDADE           VARCHAR2(20) NULL,
       COD_ESTADO           CHAR(3) NULL
);

CREATE UNIQUE INDEX cp_XPKcidade ON cp_cidade
(
       COD_CIDADE                     ASC
);

CREATE INDEX cp_XIF1cidade ON cp_cidade
(
       COD_ESTADO                     ASC
);


ALTER TABLE cp_cidade
       ADD CONSTRAINT cp_XPKcidade PRIMARY KEY (COD_CIDADE);


DROP TABLE cp_estado CASCADE CONSTRAINTS;

CREATE TABLE cp_estado (
       COD_ESTADO           CHAR(3) NOT NULL,
       NOM_ESTADO           VARCHAR2(50) NULL,
       COD_PAIS             NUMBER(3) NULL
);

CREATE UNIQUE INDEX cp_XPKestado ON cp_estado
(
       COD_ESTADO                     ASC
);

CREATE INDEX cp_XIF1estado ON cp_estado
(
       COD_PAIS                       ASC
);


ALTER TABLE cp_estado
       ADD CONSTRAINT cp_XPKestado PRIMARY KEY (COD_ESTADO);


DROP TABLE cp_pais CASCADE CONSTRAINTS;

CREATE TABLE cp_pais (
       COD_PAIS             NUMBER(3) NOT NULL,
       NOM_PAIS             VARCHAR2(50) NULL
);

CREATE UNIQUE INDEX cp_XPKpais ON cp_pais
(
       COD_PAIS                       ASC
);


ALTER TABLE cp_pais
       ADD CONSTRAINT cp_XPKpais PRIMARY KEY (COD_PAIS);


DROP TABLE cp_tipo_movimento_estoque CASCADE CONSTRAINTS;

CREATE TABLE cp_tipo_movimento_estoque (
       COD_TIPO_MOVIMENTO_ESTOQUE NUMBER(2) NOT NULL,
       DES_TIPO_MOVIMENTO_ESTOQUE VARCHAR2(50) NULL,
       STA_SAIDA_ENTRADA    CHAR(1) NULL
);

CREATE UNIQUE INDEX cp_XPKtipo_movimento_estoque ON cp_tipo_movimento_estoque
(
       COD_TIPO_MOVIMENTO_ESTOQUE     ASC
);


ALTER TABLE cp_tipo_movimento_estoque
       ADD CONSTRAINT cp_XPKtipo_movimento_estoque PRIMARY KEY (
              COD_TIPO_MOVIMENTO_ESTOQUE);


ALTER TABLE cp_movimento_estoque
       ADD CONSTRAINT cp_R_24
              FOREIGN KEY (COD_TIPO_MOVIMENTO_ESTOQUE)
                             REFERENCES cp_tipo_movimento_estoque  (
              COD_TIPO_MOVIMENTO_ESTOQUE);


ALTER TABLE cp_movimento_estoque
       ADD CONSTRAINT cp_R_17
              FOREIGN KEY (COD_PRODUTO)
                             REFERENCES cp_produto  (COD_PRODUTO);


ALTER TABLE cp_produto_composto
       ADD CONSTRAINT cp_R_16
              FOREIGN KEY (COD_PRODUTO_RELACIONADO)
                             REFERENCES cp_produto  (COD_PRODUTO);


ALTER TABLE cp_produto_composto
       ADD CONSTRAINT cp_R_15
              FOREIGN KEY (COD_PRODUTO)
                             REFERENCES cp_produto  (COD_PRODUTO);


ALTER TABLE cp_historico_pedido
       ADD CONSTRAINT cp_R_25
              FOREIGN KEY (COD_VENDEDOR)
                             REFERENCES cp_vendedor  (COD_VENDEDOR);


ALTER TABLE cp_historico_pedido
       ADD CONSTRAINT cp_R_19
              FOREIGN KEY (COD_PEDIDO)
                             REFERENCES cp_pedido  (COD_PEDIDO);


ALTER TABLE cp_historico_pedido
       ADD CONSTRAINT cp_R_9
              FOREIGN KEY (COD_CLIENTE)
                             REFERENCES cp_cliente  (COD_CLIENTE);


ALTER TABLE cp_historico_pedido
       ADD CONSTRAINT cp_R_8
              FOREIGN KEY (SEQ_ENDERECO_CLIENTE)
                             REFERENCES cp_endereco_cliente  (
              SEQ_ENDERECO_CLIENTE);


ALTER TABLE cp_item_pedido
       ADD CONSTRAINT cp_R_3
              FOREIGN KEY (COD_PRODUTO)
                             REFERENCES cp_produto  (COD_PRODUTO);


ALTER TABLE cp_item_pedido
       ADD CONSTRAINT cp_R_2
              FOREIGN KEY (COD_PEDIDO)
                             REFERENCES cp_pedido  (COD_PEDIDO);


ALTER TABLE cp_pedido
       ADD CONSTRAINT cp_R_14
              FOREIGN KEY (COD_USUARIO)
                             REFERENCES cp_usuario  (COD_USUARIO);


ALTER TABLE cp_pedido
       ADD CONSTRAINT cp_R_12
              FOREIGN KEY (COD_VENDEDOR)
                             REFERENCES cp_vendedor  (COD_VENDEDOR);


ALTER TABLE cp_pedido
       ADD CONSTRAINT cp_R_7
              FOREIGN KEY (COD_PEDIDO_RELACIONADO)
                             REFERENCES cp_pedido  (COD_PEDIDO);


ALTER TABLE cp_pedido
       ADD CONSTRAINT cp_R_6
              FOREIGN KEY (SEQ_ENDERECO_CLIENTE)
                             REFERENCES cp_endereco_cliente  (
              SEQ_ENDERECO_CLIENTE);


ALTER TABLE cp_pedido
       ADD CONSTRAINT cp_R_1
              FOREIGN KEY (COD_CLIENTE)
                             REFERENCES cp_cliente  (COD_CLIENTE);


ALTER TABLE cp_cliente_vendedor
       ADD CONSTRAINT cp_R_11
              FOREIGN KEY (COD_VENDEDOR)
                             REFERENCES cp_vendedor  (COD_VENDEDOR);


ALTER TABLE cp_cliente_vendedor
       ADD CONSTRAINT cp_R_10
              FOREIGN KEY (COD_CLIENTE)
                             REFERENCES cp_cliente  (COD_CLIENTE);


ALTER TABLE cp_endereco_cliente
       ADD CONSTRAINT cp_R_22
              FOREIGN KEY (COD_CIDADE)
                             REFERENCES cp_cidade  (COD_CIDADE);


ALTER TABLE cp_endereco_cliente
       ADD CONSTRAINT cp_R_5
              FOREIGN KEY (COD_TIPO_ENDERECO)
                             REFERENCES cp_tipo_endereco  (
              COD_TIPO_ENDERECO);


ALTER TABLE cp_endereco_cliente
       ADD CONSTRAINT cp_R_4
              FOREIGN KEY (COD_CLIENTE)
                             REFERENCES cp_cliente  (COD_CLIENTE);


ALTER TABLE cp_estoque_produto
       ADD CONSTRAINT cp_R_20
              FOREIGN KEY (COD_ESTOQUE)
                             REFERENCES cp_estoque  (COD_ESTOQUE);


ALTER TABLE cp_estoque_produto
       ADD CONSTRAINT cp_R_18
              FOREIGN KEY (COD_PRODUTO)
                             REFERENCES cp_produto  (COD_PRODUTO);


ALTER TABLE cp_cidade
       ADD CONSTRAINT cp_R_21
              FOREIGN KEY (COD_ESTADO)
                             REFERENCES cp_estado  (COD_ESTADO);


ALTER TABLE cp_estado
       ADD CONSTRAINT cp_R_23
              FOREIGN KEY (COD_PAIS)
                             REFERENCES cp_pais  (COD_PAIS);











