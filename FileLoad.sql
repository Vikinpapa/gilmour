USE [mdrr]
GO
/****** Object:  StoredProcedure [dbo].[FileLoad]    Script Date: 04.04.2023 16:10:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[FileLoad](
@fileid int)

as
begin

declare 
@poitem int,
@poitem1 int,
@poitem2 int,
@poitem3 int,
@subitem nvarchar(10),
@itmid int,
@qty decimal(10, 3),
@umid int,
@coliid int, 
@soid int

declare c cursor local static for select  a.[po item], case when isnumeric(a.[po sub-item])=0 then 0 else a.[po sub-item] end, itm.id as itemid ,
 a.quantity, um.id as umid, coli.id as coliid, so.id as soid
 from ##SO_PL  a
 join so on so.number = a.[name of document]
 join items itm on a.tag = itm.tagcode and a.ident = itm.identcode and a.[item description] = itm.descr and a.[russian translation] = itm.descrru
 join UM on um.name = a.units
 join coli on coli.name = a.[colli number]
 open c
 while 1=1 begin
	fetch next from c into @poitem,@subitem,@itmid,@qty,@umid,@coliid, @soid
	if @@FETCH_STATUS <>0 break

		insert into solines (soid, poitem, posubitem, itemid, qty, umid, coliid) values (@soid, @poitem,@subitem,@itmid,@qty,@umid,@coliid)

	end
close c
deallocate c

end





