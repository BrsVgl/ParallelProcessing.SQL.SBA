CREATE FUNCTION [dbo].[GenerateMd5]
(
      -- Add the parameters for the function here
      @strValue nvarchar(max)
)
RETURNS nvarchar(32)
AS
BEGIN
      -- Declare the return variable here
      declare @strResult nvarchar(32)
      -- Generate the MD5
      set @strResult = SubString(master.dbo.fn_varbintohexstr(HashBytes('MD5', @strValue)), 3, 32)
     
      -- Return the result of the function
      RETURN @strResult
END