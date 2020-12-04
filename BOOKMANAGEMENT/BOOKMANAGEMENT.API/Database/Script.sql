USE [master]
GO
/****** Object:  Database [BookAPI]    Script Date: 12/4/2020 11:47:56 AM ******/
CREATE DATABASE [BookAPI]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BookAPI', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BookAPI.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BookAPI_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BookAPI_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [BookAPI] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BookAPI].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BookAPI] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BookAPI] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BookAPI] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BookAPI] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BookAPI] SET ARITHABORT OFF 
GO
ALTER DATABASE [BookAPI] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BookAPI] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BookAPI] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BookAPI] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BookAPI] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BookAPI] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BookAPI] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BookAPI] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BookAPI] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BookAPI] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BookAPI] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BookAPI] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BookAPI] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BookAPI] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BookAPI] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BookAPI] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BookAPI] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BookAPI] SET RECOVERY FULL 
GO
ALTER DATABASE [BookAPI] SET  MULTI_USER 
GO
ALTER DATABASE [BookAPI] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BookAPI] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BookAPI] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BookAPI] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BookAPI] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'BookAPI', N'ON'
GO
ALTER DATABASE [BookAPI] SET QUERY_STORE = OFF
GO
USE [BookAPI]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 12/4/2020 11:47:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[BookId] [int] IDENTITY(1,1) NOT NULL,
	[BookName] [nchar](500) NOT NULL,
	[Author] [nchar](500) NOT NULL,
	[Description] [nchar](500) NULL,
	[Year] [int] NULL,
	[Count] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[BookId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateBook]    Script Date: 12/4/2020 11:47:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ngọc Phước
-- Create date: 04/12/2020
-- Description:	Create Book
-- =============================================
CREATE PROC [dbo].[sp_CreateBook]
	@BookName NVARCHAR(500),
	@Author NVARCHAR(500),
	@Description NVARCHAR(500),
	@Year INT,
	@Count INT
AS
BEGIN
BEGIN
	DECLARE @BookId	INT = 0,
			@Message	NVARCHAR(200) = 'Something went wrong, please contact administrator.'

	BEGIN TRY
		IF(@BookName IS NULL OR @BookName = '')
		BEGIN
			SET @Message = 'Book name is required!'
		END
		ELSE
		BEGIN
			IF(EXISTS(SELECT * FROM Book WHERE BookName = @BookName))
			BEGIN
				SET @Message = 'Book name is exists.'
			END
			ELSE
			BEGIN
				INSERT INTO [dbo].[Book]
					   ([BookName],
					   [Author],
					   [Description],
					   [Year],
					   [Count],
					   [IsDeleted])
				 VALUES
					   (@BookName,@Author,@Description,@Year,@Count,0)

				SET @BookId = SCOPE_IDENTITY()
				SET @Message = 'Book has been created successfully!'
			END
		END
		SELECT @BookId AS BookId,@BookName AS BookName,@Author AS Author, @Description AS Description,
		@Year AS Year,@Count AS Count ,@Message AS [Message]
	END TRY
	BEGIN CATCH
		SELECT @BookId AS BookId,@BookName AS BookName,@Author AS Author, @Description AS Description,
		@Year AS Year,@Count AS Count ,@Message AS [Message]
	END CATCH
	END
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteBook]    Script Date: 12/4/2020 11:47:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ngọc Phước
-- Create date: 04/12/2020
-- Description:	Delete Book
-- =============================================
CREATE PROC [dbo].[sp_DeleteBook]
	@BookId INT
AS
BEGIN
 DECLARE @Message  NVARCHAR(200) = 'Something went wrong, please contact administrator.'

 BEGIN TRAN
	BEGIN TRY
		IF(ISNULL(@BookId,0) = 0)
		BEGIN
			SET @Message = 'BookId is required!'
		END
		ELSE
		BEGIN
				IF(NOT EXISTS(SELECT * FROM Book WHERE BookId = @BookId))
				BEGIN
					SET @Message = 'Can not found BookId!'	
				END
				ELSE
					BEGIN
					IF(EXISTS(SELECT * FROM Book WHERE BookId = @BookId AND IsDeleted = 1))
					BEGIN
					SET @Message ='Book does not exist' 
					END 
					ELSE
					BEGIN
						UPDATE Book
						SET    IsDeleted =1
						WHERE BookId = @BookId
						SET @Message = 'Book has been delete successfully!'			
					END
				END
			END
		SELECT @Message AS [Message] , @BookId AS BookId
		COMMIT TRAN
	END TRY
  BEGIN CATCH
    SELECT @Message AS [Message] , @BookId AS BookId
    ROLLBACK TRAN
  END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetBooks]    Script Date: 12/4/2020 11:47:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ngọc Phước
-- Create date: 04/12/2020
-- Description:	Get All Book
-- =============================================
CREATE PROC [dbo].[sp_GetBooks]
AS
BEGIN
	SELECT BookId,BookName,Author,Description,Year,Count
	FROM Book
	WHERE IsDeleted = 0
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetBooksId]    Script Date: 12/4/2020 11:47:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ngọc Phước
-- Create date: 04/12/2020
-- Description:	Get Books By Id
-- =============================================
CREATE PROC [dbo].[sp_GetBooksId]
	@BookId INT
AS
BEGIN
 DECLARE @Message  NVARCHAR(200) = 'Something went wrong, please contact administrator.'

 BEGIN TRAN
	BEGIN TRY
		IF(ISNULL(@BookId,0) = 0)
		BEGIN
			SET @Message = 'BookId is required!'
		END
		ELSE
		BEGIN
				IF(NOT EXISTS(SELECT * FROM Book WHERE BookId = @BookId))
				BEGIN
					SET @Message = 'Can not found BookId!'	
				END
				ELSE
					BEGIN
					IF(EXISTS(SELECT * FROM Book WHERE BookId = @BookId AND IsDeleted = 1))
					BEGIN
					SET @Message ='Book does not exist' 
					END 
					ELSE
					BEGIN
						SELECT BookId,BookName,Author,Description,Year,Count
						FROM Book
						WHERE IsDeleted = 0		
						SET @Message ='Show Book' 
					END
				END
			END
		COMMIT TRAN
	END TRY
  BEGIN CATCH
    ROLLBACK TRAN
  END CATCH
END
GO
USE [master]
GO
ALTER DATABASE [BookAPI] SET  READ_WRITE 
GO
