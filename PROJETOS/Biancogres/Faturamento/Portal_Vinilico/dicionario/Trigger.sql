
CREATE   TRIGGER [dbo].[TRG_BI_SA1010]
ON [dbo].[SA1010] 
AFTER INSERT, UPDATE 
AS BEGIN 

UPDATE SA1010 SET A1_YDELTBI = CONVERT(VARCHAR(19),GETDATE(),120) WHERE SA1010.R_E_C_N_O_ IN (SELECT R_E_C_N_O_ FROM Inserted)

END 
GO


CREATE   TRIGGER [dbo].[TRG_BI_SB1010]
ON [dbo].[SB1010] 
AFTER INSERT, UPDATE 
AS BEGIN 

UPDATE SB1010 SET B1_YDELTBI = CONVERT(VARCHAR(19),GETDATE(),120) WHERE SB1010.R_E_C_N_O_ IN (SELECT R_E_C_N_O_ FROM Inserted)

END 
GO


CREATE   TRIGGER [dbo].[TRG_BI_SB2010]
ON [dbo].[SB2010] 
AFTER INSERT, UPDATE 
AS BEGIN 

UPDATE SB2010 SET B2_YDELTBI = CONVERT(VARCHAR(19),GETDATE(),120) WHERE SB2010.R_E_C_N_O_ IN (SELECT R_E_C_N_O_ FROM Inserted)

END 
GO


CREATE   TRIGGER [dbo].[TRG_BI_SE4010]
ON [dbo].[SE4010] 
AFTER INSERT, UPDATE 
AS BEGIN 

UPDATE SE4010 SET E4_YDELTBI = CONVERT(VARCHAR(19),GETDATE(),120) WHERE SE4010.R_E_C_N_O_ IN (SELECT R_E_C_N_O_ FROM Inserted)

END 
GO


CREATE   TRIGGER [dbo].[TRG_BI_SC5010]
ON [dbo].[SC5010] 
AFTER INSERT, UPDATE 
AS BEGIN 

UPDATE SC5010 SET C5_YDELTBI = CONVERT(VARCHAR(19),GETDATE(),120) WHERE SC5010.R_E_C_N_O_ IN (SELECT R_E_C_N_O_ FROM Inserted)

END 
GO


CREATE   TRIGGER [dbo].[TRG_BI_DA0010]
ON [dbo].[DA0010] 
AFTER INSERT, UPDATE 
AS BEGIN 

UPDATE DA0010 SET DA0_YDELTB = CONVERT(VARCHAR(19),GETDATE(),120) WHERE DA0010.R_E_C_N_O_ IN (SELECT R_E_C_N_O_ FROM Inserted)

END 
GO


CREATE   TRIGGER [dbo].[TRG_BI_DA1010]
ON [dbo].[DA1010] 
AFTER INSERT, UPDATE 
AS BEGIN 

UPDATE DA1010 SET DA1_YDELTB = CONVERT(VARCHAR(19),GETDATE(),120) WHERE DA1010.R_E_C_N_O_ IN (SELECT R_E_C_N_O_ FROM Inserted)

END 
GO