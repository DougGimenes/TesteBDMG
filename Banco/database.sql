CREATE DATABASE [TesteBDMG]
GO

USE [TesteBDMG]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Clientes](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[CPF] [varchar](11) NOT NULL,
	[DataNascimento] [date] NULL,
	[Status] [bit] NOT NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Fornecedores](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[NomeFantasia] [varchar](100) NOT NULL,
	[RazaoSocial] [varchar](100) NOT NULL,
	[CNPJ] [varchar](14) NOT NULL,
	[Status] [bit] NOT NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Itens](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodProduto] [int] NOT NULL,
	[CodVenda] [int] NOT NULL,
	[Quantidade] [int] NOT NULL,
	[ValorTotal] [decimal](19, 2) NOT NULL,
	[PrecoUnitario] [decimal](19, 2) NOT NULL,
 CONSTRAINT [PK_Itens] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Produtos](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[CodFornecedor] [int] NOT NULL,
	[PrecoUnitario] [decimal](19, 2) NOT NULL,
	[Status] [bit] NOT NULL,
 CONSTRAINT [PK_Produtos] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Pedidos](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodCliente] [int] NOT NULL,
	[DataHoraVenda] [datetime] NOT NULL,
	[ValorTotal] [decimal](19, 2) NOT NULL,
	[Status] [bit] NOT NULL,
 CONSTRAINT [PK_Pedidos] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Pedidos]  WITH CHECK ADD  CONSTRAINT [FK_Pedidos_Clientes] FOREIGN KEY([CodCliente])
REFERENCES [dbo].[Clientes] ([Codigo])
GO

ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Clientes]
GO

ALTER TABLE [dbo].[Itens]  WITH CHECK ADD  CONSTRAINT [FK_Itens_Pedidos] FOREIGN KEY([CodVenda])
REFERENCES [dbo].[Pedidos] ([Codigo])
GO

ALTER TABLE [dbo].[Itens] CHECK CONSTRAINT [FK_Itens_Pedidos]
GO

ALTER TABLE [dbo].[Itens]  WITH CHECK ADD  CONSTRAINT [FK_Itens_Produtos] FOREIGN KEY([CodProduto])
REFERENCES [dbo].[Produtos] ([Codigo])
GO

ALTER TABLE [dbo].[Itens] CHECK CONSTRAINT [FK_Itens_Produtos]
GO

ALTER TABLE [dbo].[Produtos]  WITH NOCHECK ADD  CONSTRAINT [FK_Produtos_Fornecedores] FOREIGN KEY([Codigo])
REFERENCES [dbo].[Fornecedores] ([Codigo])
NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].[Produtos] CHECK CONSTRAINT [FK_Produtos_Fornecedores]
GO




