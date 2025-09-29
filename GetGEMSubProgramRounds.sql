USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramRounds]    Script Date: 29/09/2025 12:32:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 29/9/2025
-- Description:	Gets the rounds associated with a subprogram
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgramRounds]
@ProgramId INT,
@SubProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;       
            SELECT
                  t.Time_Period_ID
                  , t.Name
                  , t.Description
                  , t.Start_Date
                  , t.Submission_Open_Date
                  , t.End_Date
                  , t.Host_Institution_Warning_Date
                  , t.Budget_Amount
                  , t.Shortlist_Multiplier_1
                  , t.Shortlist_Multiplier_2
                  , t.Budget_Variation_Allowance
                  , t.Budget_Cap_Per_Application
                  , t.maximum_contract_value
                  , t.Uro_ID
                  , t.Brief_Outline
                  , t.Draft
                  , t.Recalled
                  , t.Approach
                  , t.Invitees_Only
                  , t.Prepanel_Required
                  , t.grant_manager_stakeholder_id
                  , t.funding_period_start_date
                  , t.funding_period_end_date
				  , tpx.direct_selection       
                  
               FROM
                  TimePeriod t
               LEFT OUTER JOIN
                  [vw_EECA_TP_TimePeriods] tpx ON tpx.time_period_id = t.time_period_id
            
               LEFT OUTER JOIN
                  STKH_Stakeholders       stkh   ON    stkh.stakeholder_id   =  t.grant_manager_stakeholder_id
               INNER JOIN
                  -- Select distinct, because there is no unique constraint on this table.
                  ( SELECT DISTINCT Time_Period_ID FROM TimePeriodSubprogram WHERE @SubProgramId = 34 ) tss ON tss.Time_Period_ID = t.Time_Period_ID
               WHERE
                  t.Program_ID = @ProgramId
            
END

