USE [Genbank];

-----------------------------------------
-- Haupttabelle
-----------------------------------------
GO

CREATE TABLE Akzessionen
(
	AKZ_Nummer NVARCHAR(15) NOT NULL UNIQUE,
	Datensatz_komplett BIT,
	CONSTRAINT PK_AKZ_Nummer PRIMARY KEY (AKZ_Nummer)
);

---------------------------------------------------
-- Literaturtabellen
---------------------------------------------------
GO
CREATE TABLE Literatur
(
	Lit_id INT NOT NULL,
	Autor NVARCHAR(200),
	Jahr INTEGER,
	Titel NVARCHAR(MAX),
	Publizist NVARCHAR(200),
	Link NVARCHAR(200),
	CONSTRAINT PK_Lit_id_Literatur PRIMARY KEY (Lit_id)
);

CREATE TABLE Quellenverzeichnis
(	
	AKZ_Nummer NVARCHAR(15) NOT NULL,
	Lit_id INT NOT NULL,
	CONSTRAINT FK_AKZ_NUMMER_Quellenverzeichnis_Delete FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE,
	CONSTRAINT FK_AKZ_NUMMER_Quellenverzeichnis_Update FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE,
	CONSTRAINT FK_Lit_id_Quellenverzeichnis_Update FOREIGN KEY (Lit_ID) REFERENCES Literatur ON UPDATE CASCADE, 
    CONSTRAINT FK_Lit_id_Quellenverzeichnis_Delete FOREIGN KEY (Lit_ID) REFERENCES Literatur ON DELETE CASCADE
);

--------------------------------------------------
-- Orttabelle
--------------------------------------------------
GO
CREATE TABLE Orte
(
	Ort_id INT NOT NULL,
	ort_name NVARCHAR(200) NOT NULL,
	Strasse NVARCHAR(200),
	plz NVARCHAR(200),
	Ort NVARCHAR(200),
	CONSTRAINT PK_Ort_ID PRIMARY KEY (Ort_ID)
);

GO

CREATE TABLE Zuechter
(
	Zuechter_id INT NOT NULL,
	Zuechter_name NVARCHAR(200) NOT NULL, -- Zuechtername nicht normiert, da in Literatur nicht immer Vor und Nachname bekannt...
	Strasse NVARCHAR(200),
	plz NVARCHAR(200),
	Ort NVARCHAR(200),
	CONSTRAINT PK_ZuechterID PRIMARY KEY (Zuechter_ID)
);

--------------------------------------------------
-- Eigenschaften
--------------------------------------------------
GO
CREATE TABLE Eigenschaften
(
	AKZ_Nummer NVARCHAR(15) UNIQUE NOT NULL,
	ID_vorOrt NVARCHAR(15),
	Sortenname NVARCHAR(200),
	Synonyme NVARCHAR(200),
	Verifizierung SMALLINT CHECK (VERIFIZIERUNG BETWEEN 0 and 3),
	Aufnahmedatum DATE,
	Einrichtung INT,
	Zuechtungsjahr INT CHECK (Zuechtungsjahr between 0 AND 9999),
	Zuechter INT,
	Bemerkung_oeffentlich NVARCHAR(MAX),
	Bemerkung_intern NVARCHAR(MAX)
	CONSTRAINT FK_AKZ_NUMMER_Eigenschaften_Delete FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE,
	CONSTRAINT FK_AKZ_NUMMER_Eigenschaften_Update FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE,
	CONSTRAINT FK_Ort_ID_EigenschaftenEinrichtung_Update FOREIGN KEY (Einrichtung) REFERENCES Orte (Ort_ID) ON UPDATE CASCADE, 
	CONSTRAINT FK_Ort_ID_EigenschaftenEinrichtung_delete FOREIGN KEY (Einrichtung) REFERENCES Orte (Ort_ID) ON DELETE CASCADE, 
	CONSTRAINT FK_Zuechter_ID_EigenschaftenZuechter_Update FOREIGN KEY (Zuechter) REFERENCES Zuechter (Zuechter_ID) ON UPDATE CASCADE, 
	CONSTRAINT FK_Zuechter_ID_EigenschaftenZuechter_delete FOREIGN KEY (Zuechter) REFERENCES Zuechter (Zuechter_ID) ON DELETE CASCADE
);

------------------------------------
--Qualitative Tabelle
------------------------------------
GO
CREATE TABLE Qualitativ
(
	AKZ_Nummer NVARCHAR(15) UNIQUE NOT NULL,
	Anbaukultur NVARCHAR(50), 
	pH_Wert FLOAT,
	Wachstumstyp NVARCHAR(50),
	remontierend NVARCHAR(50),
	Standfestigkeit NVARCHAR(50),
	Winterhaerte NVARCHAR(50),
	Stiel_Verbaenderung NVARCHAR(50),
	Trieb_Farbe NVARCHAR(50),
	Blattspreite_Lappung NVARCHAR(50),
	Blattspreite_Form NVARCHAR(50),
	Blattspreite_Basis NVARCHAR(50),
	Blattspreite_Hauptfarbe NVARCHAR(50),
	Blattspreite_sekfarbe NVARCHAR(50),
	Blattspreite_Glanz NVARCHAR(50),
	Bluetenstand_Form NVARCHAR(50),
	Bluetenstand_Regenfestigkeit NVARCHAR(50),
	Bluetenstand_fertileBlueten NVARCHAR(50),
	Anordnung_sterileBlueten NVARCHAR(50),
	SterileBluete_Typ NVARCHAR(50),
	SterileBluete_Hauptfarbe NVARCHAR(50),
	SterileBluete_sekundaerfarbe NVARCHAR(50),
	sterileBluete_verteilung_sekundaerfarbe NVARCHAR(50),
	Verfaerbung_Abbluete NVARCHAR(50),
	FertileBluete_Farbe NVARCHAR(50),
	Blatt_Sonnenbrand NVARCHAR(50),
	Bemerkung NVARCHAR(MAX)
		CONSTRAINT FK_AKZ_NUMMER_Qualitativ_Delete FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE,
		CONSTRAINT FK_AKZ_NUMMER_Qualitativ_Update FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON Update CASCADE,
		CONSTRAINT chk_Blatt_Sonnenbrand CHECK (Blatt_Sonnenbrand IN ('fehlend oder sehr gering', 'mittel', 'stark', 'nicht anwendbar')),
		CONSTRAINT chk_Verfaerbung_Abbluete CHECK (Verfaerbung_Abbluete IN ('fehlend oder sehr gering', 'mittel', 'stark', 'nicht anwendbar')),
		CONSTRAINT chk_SterileBluetenTyp CHECK (SterileBluete_Typ IN ('einfach', 'gefüllt')),
		CONSTRAINT chk_AnordnungsterileBlueten CHECK (Anordnung_sterileBlueten IN ('unregelmäßig', 'in einem Quirl', 'in zwei oder mehr Quirlen', 'nicht anwendbar')),
		CONSTRAINT chk_BluetenstandFertileBlueten CHECK (Bluetenstand_fertileBlueten IN ('sehr deutlich', 'undeutlich oder etwas deutlich', 'mäßig deutlich')),
		CONSTRAINT chk_BluetenRegenfest CHECK (Bluetenstand_Regenfestigkeit IN ('stark', 'gering', 'nicht anwendbar')),
		CONSTRAINT chk_BluetenstandForm CHECK (Bluetenstand_Form IN ('kegelförmig', 'kugelförmig', 'rispenartig', 'abgeflacht')),
		CONSTRAINT chk_BlattGlanz CHECK (Blattspreite_Glanz IN ('stark', 'mäßig', 'fehlend oder gering', 'gering')),
		CONSTRAINT chk_BlattBasis CHECK (Blattspreite_Basis IN ('abgerundet', 'spitz', 'stumpf', 'kreisförmig', 'herzförming')),
		CONSTRAINT chk_BlattForm CHECK (Blattspreite_Form IN ('eiförmig', 'elliptisch', 'verkehrt eiförmig', 'kreisförmig', 'lanzettlich')),
		CONSTRAINT chk_BlattLappung CHECK (Blattspreite_Lappung IN ('vorhanden', 'fehlend')),
		CONSTRAINT chk_verbaenderung CHECK (Stiel_verbaenderung IN ('vorhanden', 'fehlend', 'schwankend mit Haupteindruck: fehlend', 'schwankend mit Haupteindruck: vorhanden')),
		CONSTRAINT chk_Winterhaerte CHECK (Winterhaerte IN ('stark', 'mittel', 'sehr gering', 'nicht anwendbar')),
		CONSTRAINT chk_standfestigkeit CHECK (standfestigkeit IN ('fehlend oder sehr gering', 'mittel', 'stark', 'nicht anwendbar')),
		CONSTRAINT chk_remontierend CHECK (Wachstumstyp IN ('vorhanden', 'fehlend', 'nicht anwendbar')),
		CONSTRAINT chk_Wachstum CHECK (Wachstumstyp IN ('kletternd', 'nicht kletternd')),
		CONSTRAINT chk_pH CHECK (ph_Wert between 0 AND 14),
		CONSTRAINT chk_Anbau CHECK (Anbaukultur IN ('Gewächshaus', 'Freiland', 'Topfkultur'))
);


--------------------------------------------------
-- Quantitative Tabellen
--------------------------------------------------
GO
CREATE TABLE Mittelwerte (
	AKZ_Nummer NVARCHAR(15) NOT NULL UNIQUE,
	BluetenbreiteMW FLOAT,
	BluetenlaengeMW FLOAT,
	BluetenhoeheMW FLOAT,
	PflanzenhoeheMW FLOAT,
	PflanzenbreiteMW FLOAT,
	BlattbreiteMW FLOAT,
	BlattlaengeMW FLOAT,
	CONSTRAINT FK_AKZ_NUMMER_Mittelwerte_DELETE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE,
	CONSTRAINT FK_AKZ_NUMMER_Mittelwerte_UPDATE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE 
);

-- Bluetenlaenge
GO
CREATE TABLE Bluetenlaenge
(

	AKZ_Nummer NVARCHAR(15) NOT NULL,
	Messungen FLOAT NOT NULL,
	CONSTRAINT FK_AKZ_NUMMER_Bluetenlaenge_DELETE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE, 
	CONSTRAINT FK_AKZ_NUMMER_Bluetenlaenge_UPDATE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE 
);

GO
CREATE TRIGGER BluetenlaengeMWberechnen
	ON Bluetenlaenge
	AFTER INSERT, UPDATE 
	AS
	BEGIN
		DECLARE @AKZ NVARCHAR(15);
		DECLARE @Messung FLOAT;
		DECLARE Insert_Cursor CURSOR FOR
			SELECT * FROM INSERTED;
		OPEN Insert_Cursor;
			FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF (SELECT COUNT(AKZ_Nummer) FROM Mittelwerte WHERE AKZ_Nummer = @AKZ) = 0
					BEGIN
						BEGIN TRY
							INSERT INTO Mittelwerte (AKZ_Nummer) VALUES (@AKZ);
						END TRY
						BEGIN CATCH
							PRINT 'AKZ-Nummer als Primaerschluessel vergeben?'
						END CATCH;	
					END;
					SELECT Messungen INTO #temp FROM Bluetenlaenge WHERE Bluetenlaenge.AKZ_Nummer = @AKZ;
					DECLARE @mw FLOAT = (SELECT AVG(Messungen) FROM #temp);
					UPDATE Mittelwerte SET BluetenlaengeMW = @mw WHERE (Mittelwerte.AKZ_Nummer = (@AKZ));
					DROP TABLE #temp
					FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
				END;
			CLOSE Insert_Cursor;
			DEALLOCATE Insert_Cursor;
	END;
GO

-- Bluetenbreite
CREATE TABLE Bluetenbreite 
(	

	AKZ_Nummer NVARCHAR(15) NOT NULL,
	Messungen FLOAT NOT NULL,
	CONSTRAINT FK_AKZ_NUMMER_Bluetenbreite_DELETE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE, 	
	CONSTRAINT FK_AKZ_NUMMER_Bluetenbreite_UPDATE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE
);

GO
CREATE TRIGGER BluetenbreiteMWberechnen
	ON Bluetenbreite
	AFTER INSERT, UPDATE 
	AS
	BEGIN
		DECLARE @AKZ NVARCHAR(15);
		DECLARE @Messung FLOAT;
		DECLARE Insert_Cursor CURSOR FOR
			SELECT * FROM INSERTED;
		OPEN Insert_Cursor;
			FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF (SELECT COUNT(AKZ_Nummer) FROM Mittelwerte WHERE AKZ_Nummer = @AKZ) = 0
					BEGIN
						BEGIN TRY
							INSERT INTO Mittelwerte (AKZ_Nummer) VALUES (@AKZ);
						END TRY
						BEGIN CATCH
							PRINT 'AKZ-Nummer als Primaerschluessel vergeben?'
						END CATCH;	
					END;
					SELECT Messungen INTO #temp FROM Bluetenbreite WHERE Bluetenbreite.AKZ_Nummer = @AKZ;
					DECLARE @mw FLOAT = (SELECT AVG(Messungen) FROM #temp);
					UPDATE Mittelwerte SET BluetenbreiteMW = @mw WHERE (Mittelwerte.AKZ_Nummer = (@AKZ));
					DROP TABLE #temp
					FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
				END;
			CLOSE Insert_Cursor;
			DEALLOCATE Insert_Cursor;
	END;

GO
-- Bluetenhoehe
CREATE TABLE Bluetenhoehe
(	

	AKZ_Nummer NVARCHAR(15) NOT NULL,
	Messungen FLOAT NOT NULL,
    CONSTRAINT FK_AKZ_NUMMER_Bluetenhoehe_DELETE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE,
	CONSTRAINT FK_AKZ_NUMMER_Bluetenhoehe_UPDATE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE
);

GO
CREATE TRIGGER BluetenhoeheMWberechnen
	ON Bluetenhoehe
	AFTER INSERT, UPDATE 
	AS
	BEGIN
		DECLARE @AKZ NVARCHAR(15);
		DECLARE @Messung FLOAT;
		DECLARE Insert_Cursor CURSOR FOR
			SELECT * FROM INSERTED;
		OPEN Insert_Cursor;
			FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF (SELECT COUNT(AKZ_Nummer) FROM Mittelwerte WHERE AKZ_Nummer = @AKZ) = 0
					BEGIN
						BEGIN TRY
							INSERT INTO Mittelwerte (AKZ_Nummer) VALUES (@AKZ);
						END TRY
						BEGIN CATCH
							PRINT 'AKZ-Nummer als Primaerschluessel vergeben?'
						END CATCH;					
					END;
					SELECT Messungen INTO #temp FROM Bluetenhoehe WHERE Bluetenhoehe.AKZ_Nummer = @AKZ;
					DECLARE @mw FLOAT = (SELECT AVG(Messungen) FROM #temp);
					UPDATE Mittelwerte SET BluetenhoeheMW = @mw WHERE (Mittelwerte.AKZ_Nummer = (@AKZ));
					DROP TABLE #temp
					FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
				END;
			CLOSE Insert_Cursor;
			DEALLOCATE Insert_Cursor;
	END;
GO

--Pflanzenhoehe
CREATE TABLE Pflanzenhoehe
(	

	AKZ_Nummer NVARCHAR(15) NOT NULL,
	Messungen FLOAT NOT NULL,	
	CONSTRAINT FK_AKZ_NUMMER_Pflanzenhoehe_DELETE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE,
	CONSTRAINT FK_AKZ_NUMMER_Pflanzenhoehe_UPDATE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE 
);
GO
CREATE TRIGGER PflanzenhoeheMWberechnen
	ON pflanzenhoehe
	AFTER INSERT, UPDATE 
	AS
	BEGIN
		DECLARE @AKZ NVARCHAR(15);
		DECLARE @Messung FLOAT;
		DECLARE Insert_Cursor CURSOR FOR
			SELECT * FROM INSERTED;
		OPEN Insert_Cursor;
			FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF (SELECT COUNT(AKZ_Nummer) FROM Mittelwerte WHERE AKZ_Nummer = @AKZ) = 0
					BEGIN
						BEGIN TRY
							INSERT INTO Mittelwerte (AKZ_Nummer) VALUES (@AKZ);
						END TRY
						BEGIN CATCH
							PRINT 'AKZ-Nummer als Primaerschluessel vergeben?'
						END CATCH;
					END;
					SELECT Messungen INTO #temp FROM pflanzenhoehe WHERE pflanzenhoehe.AKZ_Nummer = @AKZ;
					DECLARE @mw FLOAT = (SELECT AVG(Messungen) FROM #temp);
					UPDATE Mittelwerte SET pflanzenhoeheMW = @mw WHERE (Mittelwerte.AKZ_Nummer = (@AKZ));
					DROP TABLE #temp
					FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
				END;
			CLOSE Insert_Cursor;
			DEALLOCATE Insert_Cursor;
	END;
GO

--Pflanzenbreite
CREATE TABLE Pflanzenbreite
(	

	AKZ_Nummer NVARCHAR(15) NOT NULL,
	Messungen FLOAT NOT NULL,
	CONSTRAINT FK_AKZ_NUMMER_Pflanzenbreite_DELETE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE,
	CONSTRAINT FK_AKZ_NUMMER_Pflanzenbreite_UPDATE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE 
);
GO

CREATE TRIGGER PflanzenbreiteMWberechnen
	ON pflanzenbreite
	AFTER INSERT, UPDATE 
	AS
	BEGIN
		DECLARE @AKZ NVARCHAR(15);
		DECLARE @Messung FLOAT;
		DECLARE Insert_Cursor CURSOR FOR
			SELECT * FROM INSERTED;
		OPEN Insert_Cursor;
			FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF (SELECT COUNT(AKZ_Nummer) FROM Mittelwerte WHERE AKZ_Nummer = @AKZ) = 0
					BEGIN
						BEGIN TRY
							INSERT INTO Mittelwerte (AKZ_Nummer) VALUES (@AKZ);
						END TRY
						BEGIN CATCH
							PRINT 'AKZ-Nummer als Primaerschluessel vergeben?'
						END CATCH;
					END;
					SELECT Messungen INTO #temp FROM pflanzenbreite WHERE pflanzenbreite.AKZ_Nummer = @AKZ;
					DECLARE @mw FLOAT = (SELECT AVG(Messungen) FROM #temp);
					UPDATE Mittelwerte SET pflanzenbreiteMW = @mw WHERE (Mittelwerte.AKZ_Nummer = (@AKZ));
					DROP TABLE #temp
					FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
				END;
			CLOSE Insert_Cursor;
			DEALLOCATE Insert_Cursor;
	END;
GO

--Blattbreite
CREATE TABLE Blattbreite
(	

	AKZ_Nummer NVARCHAR(15) NOT NULL,
	Messungen FLOAT NOT NULL,
	CONSTRAINT FK_AKZ_NUMMER_Blattbreite_DELETE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE, 
	CONSTRAINT FK_AKZ_NUMMER_Blattbreite_UPDATE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE 
);
GO

CREATE TRIGGER BlattbreiteMWberechnen
	ON blattbreite
	AFTER INSERT, UPDATE 
	AS
	BEGIN
		DECLARE @AKZ NVARCHAR(15);
		DECLARE @Messung FLOAT;
		DECLARE Insert_Cursor CURSOR FOR
			SELECT * FROM INSERTED;
		OPEN Insert_Cursor;
			FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF (SELECT COUNT(AKZ_Nummer) FROM Mittelwerte WHERE AKZ_Nummer = @AKZ) = 0
					BEGIN
						BEGIN TRY
							INSERT INTO Mittelwerte (AKZ_Nummer) VALUES (@AKZ);
						END TRY
						BEGIN CATCH
							PRINT 'AKZ-Nummer als Primaerschluessel vergeben?'
						END CATCH;
					END;
					SELECT Messungen INTO #temp FROM blattbreite WHERE blattbreite.AKZ_Nummer = @AKZ;
					DECLARE @mw FLOAT = (SELECT AVG(Messungen) FROM #temp);
					UPDATE Mittelwerte SET blattbreiteMW = @mw WHERE (Mittelwerte.AKZ_Nummer = (@AKZ));
					DROP TABLE #temp
					FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
				END;
			CLOSE Insert_Cursor;
			DEALLOCATE Insert_Cursor;
	END;
GO

--Blattlaenge
CREATE TABLE Blattlaenge
(	

	AKZ_Nummer NVARCHAR(15) NOT NULL,
	Messungen FLOAT NOT NULL,
	CONSTRAINT FK_AKZ_NUMMER_Blattlaenge_DELETE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON DELETE CASCADE, 
	CONSTRAINT FK_AKZ_NUMMER_Blattlaenge_UPDATE FOREIGN KEY (AKZ_Nummer) REFERENCES AKZESSIONEN ON UPDATE CASCADE 
);
GO
CREATE TRIGGER BlattlaengeMWberechnen
	ON blattlaenge
	AFTER INSERT, UPDATE 
	AS
	BEGIN
		DECLARE @AKZ NVARCHAR(15);
		DECLARE @Messung FLOAT;
		DECLARE Insert_Cursor CURSOR FOR
			SELECT * FROM INSERTED;
		OPEN Insert_Cursor;
			FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF (SELECT COUNT(AKZ_Nummer) FROM Mittelwerte WHERE AKZ_Nummer = @AKZ) = 0
					BEGIN
						BEGIN TRY
							INSERT INTO Mittelwerte (AKZ_Nummer) VALUES (@AKZ);
						END TRY
						BEGIN CATCH
							PRINT 'AKZ-Nummer als Primaerschluessel vergeben?'
						END CATCH;
					END;
					SELECT Messungen INTO #temp FROM blattlaenge WHERE blattlaenge.AKZ_Nummer = @AKZ;
					DECLARE @mw FLOAT = (SELECT AVG(Messungen) FROM #temp);
					UPDATE Mittelwerte SET blattlaengeMW = @mw WHERE (Mittelwerte.AKZ_Nummer = (@AKZ));
					DROP TABLE #temp
					FETCH NEXT FROM Insert_Cursor INTO @AKZ, @MESSUNG;
				END;
			CLOSE Insert_Cursor;
			DEALLOCATE Insert_Cursor;
	END;
GO

-----------------------------------------------
-- Tabellen Bulk Insert
-----------------------------------------------
CREATE PROCEDURE Tabelle_einlesen
	@Dateipfad NVARCHAR(MAX),
	@Zieltabelle NVARCHAR(MAX)
	AS
		BEGIN
			DECLARE @sql NVARCHAR(MAX) =

				N'BULK INSERT ' + QUOTENAME(@Zieltabelle) +
					' FROM ' + QUOTENAME(@Dateipfad) +
					' WITH
					(
					DATAFILETYPE = ''char'',
					FIELDTERMINATOR = '';'',
					CODEPAGE = 65001,      
					ROWTERMINATOR = ''\n'', 
					FIRSTROW = 2,
					FIRE_TRIGGERS,
					MAXERRORS =  1000
					);'
			PRINT @sql
			EXECUTE sp_executesql @sql
		END;
GO
------------------------------------------------
-- Messungen per Hand eintragen
------------------------------------------------
CREATE PROCEDURE Messungen_eintragen
	@zieltabelle NVARCHAR(MAX),
	@AKZ_Nummer NVARCHAR(MAX),
	@Messung float
	AS
		BEGIN
			DECLARE @sql NVARCHAR(MAX) = -- Quotename nicht fuer WERTE!
				N'INSERT INTO ' + QUOTENAME(@zieltabelle) +
				' (AKZ_Nummer, Messungen) VALUES 
					(''' + @AKZ_Nummer + ''', ' + CAST(@Messung AS nvarchar(10)) + 
				' );'
			PRINT @sql
			EXECUTE sp_executesql @sql
		END;
GO

-------------------------------------------------
-- Backup
-------------------------------------------------
USE [Genbank]
-- Backup als job mit schedule in SQL-Express leider nicht moeglich...
GO
	CREATE PROCEDURE Back_Up
		AS
			BEGIN
				DECLARE @jetzt DATE = GETDATE();		
				DECLARE @str NVARCHAR(100) = CAST(@jetzt AS NVARCHAR(100));
				SET @str = REPLACE(@str, ' ', '_');
				SET @str = 'C:\SQLServerBackups\Genbank_' + @str + '.bak';
				PRINT ('gespeichert unter ' + @str);
				BACKUP DATABASE [Genbank]
				TO DISK = @str
				WITH FORMAT,
				MEDIANAME = 'SQLServerBackups',
				NAME = 'Vollständige Datensicherung von Genbank'
			END;

GO


--------------------------------------------------
-- Rollenverteilung
--------------------------------------------------

-- Sichten fuer Gastnutzer
DECLARE @AKZ NVARCHAR(15);
GO
CREATE VIEW vw_Akzession_Eigenschaften
	AS
		SELECT Akzessionen.AKZ_Nummer, 
			Eigenschaften.ID_vorOrt, Eigenschaften.Sortenname, Eigenschaften.Synonyme, Eigenschaften.Verifizierung, Eigenschaften.Aufnahmedatum, 
			Orte.ort_name, Eigenschaften.Zuechtungsjahr, Zuechter.zuechter_name, Eigenschaften.Bemerkung_oeffentlich		
				FROM Akzessionen 
					LEFT JOIN Eigenschaften ON Akzessionen.AKZ_Nummer = Eigenschaften.AKZ_Nummer
					LEFT JOIN Orte ON Eigenschaften.Einrichtung = Orte.Ort_id
					LEFT JOIN Zuechter ON Eigenschaften.Zuechter = Zuechter_ID;


GO

CREATE VIEW vw_Akzession_Aufnahmen
	AS
		SELECT Akzessionen.AKZ_Nummer, Qualitativ.Anbaukultur, Qualitativ.pH_Wert, Qualitativ.Wachstumstyp, Qualitativ.Standfestigkeit, 
			Qualitativ.remontierend, Qualitativ.Winterhaerte, Qualitativ.Stiel_Verbaenderung, Qualitativ.Trieb_Farbe,
			Mittelwerte.PflanzenhoeheMW, Mittelwerte.PflanzenbreiteMW,
			Qualitativ.Blattspreite_Form, qualitativ.Blattspreite_Lappung, Blattspreite_Basis, Qualitativ.Blattspreite_Glanz, Qualitativ.Blattspreite_Hauptfarbe, Qualitativ.Blattspreite_sekfarbe,
			Mittelwerte.BlattlaengeMW, Mittelwerte.BlattbreiteMW,
			Qualitativ.Bluetenstand_Form, Qualitativ.Bluetenstand_Regenfestigkeit, Qualitativ.Bluetenstand_fertileBlueten,
			Mittelwerte.BluetenhoeheMW, Mittelwerte.BluetenbreiteMW, Mittelwerte.BluetenlaengeMW,
			Qualitativ.SterileBluete_Typ, Qualitativ.SterileBluete_Hauptfarbe, Qualitativ.SterileBluete_sekundaerfarbe, Qualitativ.sterileBluete_verteilung_sekundaerfarbe,
			qualitativ.fertilebluete_farbe, Qualitativ.Verfaerbung_Abbluete, Qualitativ.Blatt_Sonnenbrand, Qualitativ.Bemerkung
				FROM Akzessionen
					LEFT JOIN Qualitativ ON Akzessionen.AKZ_Nummer = Qualitativ.AKZ_Nummer
					LEFT JOIN Mittelwerte ON Akzessionen.AKZ_Nummer = Mittelwerte.AKZ_Nummer;

GO
CREATE OR ALTER VIEW vw_Akzession_Literatur
	AS
		SELECT Akzessionen.AKZ_Nummer, Literatur.Autor, Literatur.Jahr, Literatur.Titel, Literatur.Publizist, Literatur.Link
			FROM Akzessionen
				LEFT JOIN Quellenverzeichnis ON Akzessionen.AKZ_Nummer = Quellenverzeichnis.AKZ_Nummer
				LEFT JOIN Literatur ON Quellenverzeichnis.Lit_id = Literatur.Lit_id;

GO

--------------------------------------------------------------------
-- Logins und Benutzer
--------------------------------------------------------------------
USE master
GO
CREATE LOGIN
	Gast WITH
		PASSWORD = '',
		DEFAULT_DATABASE = Genbank;
GO
CREATE LOGIN
	Benutzer WITH
		PASSWORD = '12345',
		DEFAULT_DATABASE = Genbank;

GO

USE [Genbank]

CREATE USER
	Gast_User
	FOR LOGIN Gast;

GRANT SELECT ON vw_Akzession_Eigenschaften TO Gast_User;
GRANT SELECT ON vw_Akzession_Aufnahmen TO Gast_User;
GRANT SELECT ON vw_akzession_literatur TO Gast_User;

CREATE USER
	Benutzer_User
	For LOGIN Benutzer;

GRANT INSERT, SELECT ON Akzessionen TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Blattbreite TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Blattlaenge TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Blattlaenge TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Bluetenbreite TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Bluetenhoehe TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Bluetenlaenge TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Eigenschaften TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Literatur TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Mittelwerte TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Orte TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Pflanzenbreite TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Pflanzenhoehe TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Qualitativ TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Quellenverzeichnis TO Benutzer_User;
GRANT INSERT, SELECT, UPDATE, DELETE ON Zuechter TO Benutzer_User;
GRANT EXECUTE ON Back_Up TO Benutzer_User;
GRANT EXECUTE ON Messungen_eintragen TO Benutzer_User;







