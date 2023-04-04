SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter procedure [dbo].[checkqcf](
    @userid int,
    @mode nvarchar(20))
as 
begin

    declare 
@fnameid int,
@fnameid1 int,
@fnamen nvarchar(100),
@dir nvarchar(101), 
@dirf nvarchar(1000)

    if @mode = 'qc' begin
        set @dir  = (select dbo.getsysparam ('QC FILE EXCHANGE', 'DirectoryIN'))
    end

    if @mode = 'qc' begin
        declare c cursor local static for select top 1
            name
        from fname
        where contents = @mode and name like '%xls%'
    end

    open c
    while 1=1 begin
        fetch next from c into @fnamen
        if @@FETCH_STATUS<> 0 break

        set @dirf = @dir +'\'+@fnamen

        select @dirf 

        if @mode = 'qc' begin
            exec Upload_qc_check @filepath = @dirf, @userid = @userid
        end


    end
    close c
    deallocate c



end

GO
