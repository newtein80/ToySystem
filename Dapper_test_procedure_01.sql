USE [MANAGEAPP]
GO
/****** Object:  StoredProcedure [dbo].[SP_COMMON_CODE_LIST]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[SP_COMMON_CODE_LIST]
    @gubun					nvarchar(8)
    ,   @code_type			nvarchar(32)
    ,   @code_type_name		nvarchar(128)
	,	@code_id			nvarchar(32)
	,	@code_name			nvarchar(128)
	,	@code_val			int
	,	@use_yn				int
	,   @sort_field			nvarchar(50)
    ,   @is_desc			tinyint = 1
	,   @pagesize			int
    ,   @pageindex			int
    ,   @allCount			bigint output
as
	
set transaction isolation level read uncommitted
set nocount on

begin
    declare  
        @SQLString      nvarchar(max) = ''
        ,   @wheredata  nvarchar(max) = ''
        ,   @orderby    varchar(500) = ' order by CodeType asc'
        ,   @subquery   varchar(max) = ''
        ,	@is_desc_title varchar(10)   = ''


	if '' = @gubun or '' = isnull(@gubun, '') begin
        set @gubun = null;
    end

	if '' = @code_type or '' = isnull(@code_type, '') begin
        set @code_type = null;
    end

    if '' = @code_type_name or '' = isnull(@code_type_name, '') begin
        set @code_type_name = null;
    end

	if '' = @code_id or '' = isnull(@code_id, '') begin
        set @code_id = null;
    end

	if '' = @code_name or '' = isnull(@code_name, '') begin
        set @code_name = null;
    end

	if 'all' = @use_yn or '' = @use_yn or '' = isnull(@use_yn, '') begin
		set @use_yn = null;
    end

    if(@code_type is not null) begin
	    set @wheredata =  @wheredata + ' and CODE_TYPE like ''%' + @code_type + '%'' '
    end
    
    if(@code_type_name is not null) begin
		set @wheredata = @wheredata + ' and CODE_TYPE_NAME like ''%' + @code_type_name + '%'' '
    end

	if(@code_id is not null) begin
		set @wheredata = @wheredata + ' and CODE_ID like ''%' + @code_id + '%'' '
    end

	if(@code_name is not null) begin
		set @wheredata = @wheredata + ' and CODE_NAME like ''%' + @code_name + '%'' '
    end

	if(@use_yn is not null) begin
	    set @wheredata =  @wheredata + ' and USE_YN = ' + @use_yn + ' '
    end

    if '' = @sort_field or '' = isnull(@sort_field, '') begin
        set @orderby = ' order by CODE_TYPE asc '
    end
    else begin
        if 1 = @is_desc begin
           set @is_desc_title = 'DESC'
        end
        else begin
           set @is_desc_title = 'ASC'
        end

        set @orderby = ' order by ' + @sort_field + ' ' + @is_desc_title
    end

    declare @fromidx int
    declare @toidx   int
    set @fromidx = ((@pageindex - 1) * @pagesize) + 1
    set @toidx = @pageindex * @pagesize

    set @SQLString = ' 
declare @T_TEMP table 
(
    TEMP_SEQ 	    bigint identity primary key
    ,   CODE_TYPE   nvarchar(32)
	,	CODE_ID		nvarchar(32)
)

insert into @T_TEMP(CODE_TYPE, CODE_ID)  
select
	CODE_TYPE
	, CODE_ID
from
(
	select
		*
	from dbo.T_COMMON_CODE with(nolock)
) as t0
where 1=1

'
    set @subquery = 
'
select  
    @p_value = count(*) 
from @T_TEMP

select 
    t3.*
from 
(
    select 
        *
    from dbo.T_COMMON_CODE with(nolock)
) as t3
inner join @T_TEMP as t4
on
(
    t3.CODE_TYPE = t4.CODE_TYPE
	and t3.CODE_ID = t4.CODE_ID
)
'
    set @subquery = @subquery + ' where t4.TEMP_SEQ >= @fromidx and t4.TEMP_SEQ <= @toidx '     
    set @SQLString = @SQLString + @wheredata + @orderby + @subquery

    declare @params nvarchar(200)
    set   @params  ='@p_value int output , @toidx int, @fromidx int'
    
    exec sp_executesql  @SQLString
                      , @params
                      , @p_value = @allCount OUTPUT
                      , @fromidx = @fromidx
                      , @toidx = @toidx
                  
    select @allCount as TotCnt
end

GO
/****** Object:  StoredProcedure [dbo].[SP_COMP_LIST]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_COMP_LIST]
    @gubun				nvarchar(8)
    ,   @diag_type      nvarchar(32)
    ,   @comp_name		nvarchar(128)
	,	@standard_year	nvarchar(4)
	,	@use_yn			char(1)
	,   @create_user_id	nvarchar(16)
	,   @sort_field		nvarchar(50)
    ,   @is_desc		tinyint = 1
	,   @pagesize		int
    ,   @pageindex		int
    ,   @allCount		bigint output
as
	
set transaction isolation level read uncommitted
set nocount on

begin
    declare  
        @SQLString      nvarchar(max) = ''
        ,   @wheredata  nvarchar(max) = ''
        ,   @orderby    varchar(500) = ' order by CREATE_DT desc'
        ,   @subquery   varchar(max) = ''
        ,	@is_desc_title varchar(10)   = ''


	if 'all' = @gubun or '' = @gubun or '' = isnull(@gubun, '') begin
        set @gubun = null;
    end

	if 'all' = @diag_type or '' = @diag_type or '' = isnull(@diag_type, '') begin
		set @diag_type = null;
    end

    if '' = @comp_name or '' = isnull(@comp_name, '') begin
        set @comp_name = null;
    end

	if 'all' = @use_yn or '' = @use_yn or '' = isnull(@use_yn, '') begin
		set @use_yn = null;
    end

    if(@diag_type is not null) begin
	    set @wheredata =  @wheredata + ' and DIAG_TYPE = ''' + @diag_type + ''' '
    end
    
    if(@comp_name is not null) begin
		set @wheredata = @wheredata + ' and COMP_NAME like ''%' + @comp_name + '%'' '
    end

    if '' = @sort_field or '' = isnull(@sort_field, '') begin
        set @orderby = ' order by CREATE_DT desc '
    end
    else begin
        if 1 = @is_desc begin
           set @is_desc_title = 'DESC'
        end
        else begin
           set @is_desc_title = 'ASC'
        end

        set @orderby = ' order by ' + @sort_field + ' ' + @is_desc_title
    end

    declare @fromidx int
    declare @toidx   int
    set @fromidx = ((@pageindex - 1) * @pagesize) + 1
    set @toidx = @pageindex * @pagesize

    set @SQLString = ' 
declare @T_TEMP table 
(
    TEMP_SEQ 	    bigint identity primary key
    ,   COMP_SEQ   bigint
)

insert into @T_TEMP(COMP_SEQ)  
select
	COMP_SEQ
from
(
	select
		DIAG_TYPE
		, COMP_NAME
		, STANDARD_YEAR
		, USE_YN
		, CREATE_USER_ID
		, CREATE_DT
		, COMP_SEQ
	from dbo.T_COMP_INFO with(nolock)
) as t0
where 1=1

'
    set @subquery = 
'
select  
    @p_value = count(*) 
from @T_TEMP

select 
    t3.*
from 
(
    select 
        *
    from dbo.T_COMP_INFO with(nolock)
) as t3
inner join @T_TEMP as t4
on
(
    t3.COMP_SEQ = t4.COMP_SEQ
)
'
    set @subquery = @subquery + ' where t4.TEMP_SEQ >= @fromidx and t4.TEMP_SEQ <= @toidx '     
    set @SQLString = @SQLString + @wheredata + @orderby + @subquery

    declare @params nvarchar(200)
    set   @params  ='@p_value int output , @toidx int, @fromidx int'
    
    exec sp_executesql  @SQLString
                      , @params
                      , @p_value = @allCount OUTPUT
                      , @fromidx = @fromidx
                      , @toidx = @toidx
                  
    select @allCount as TotCnt
end

GO
/****** Object:  StoredProcedure [dbo].[SP_VULN_GROUP_LIST]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SP_VULN_GROUP_LIST]
    @comp_seq           nvarchar(32)
    ,   @diag_type      nvarchar(32)
    ,   @diag_kind      nvarchar(32)
    ,   @group_seq      nvarchar(32)
    ,   @group_name     nvarchar(128)
	,   @user_id		nvarchar(16)
	,   @sort_field		nvarchar(50)
    ,   @is_desc		tinyint = 1
	,   @pagesize		int
    ,   @pageindex		int
    ,   @allCount		bigint output
as
	
set transaction isolation level read uncommitted
set nocount on

begin
    declare  
        @SQLString      nvarchar(max) = ''
        ,   @wheredata  nvarchar(max) = ''
        ,   @orderby    varchar(500) = ' order by DIAG_KIND, GROUP_ID asc'
        ,   @subquery   varchar(max) = ''

    if 'all' = @comp_seq or '' = @comp_seq or '' = isnull(@comp_seq, '') begin
        set @comp_seq = null;
    end

    if 'all' = @diag_type or '' = @diag_type or '' = isnull(@diag_type, '') begin
    set @diag_type = null;
    end

    if 'all' = @diag_kind or '' = @diag_kind or '' = isnull(@diag_kind, '') begin
    set @diag_kind = null;
    end

    if '' = @group_name or '' = isnull(@group_name, '') begin
        set @group_name = null;
    end

    if(@comp_seq is not null) begin
	    set @wheredata =  @wheredata + ' and t5.COMP_SEQ = ''' + @comp_seq + ''' '
    end

    if(@diag_type is not null) begin
	    set @wheredata =  @wheredata + ' and t5.DIAG_TYPE = ''' + @diag_type + ''' '
    end

    if(@diag_kind is not null) begin
	    set @wheredata =  @wheredata + ' and t5.DIAG_KIND = ''' + @diag_kind + ''' '
    end

    if(@group_name is not null) begin
	    set @wheredata =  @wheredata + ' and t5.GROUP_NAME like ''%' + @group_name + '%'' '
    end

    declare @fromidx int
    declare @toidx   int
    set @fromidx = ((@pageindex - 1) * @pagesize) + 1
    set @toidx = @pageindex * @pagesize

    set @SQLString = ' 
declare @T_TEMP table 
(
    TEMP_SEQ 	    bigint identity primary key
    ,   GROUP_SEQ   bigint
)

insert into @T_TEMP(GROUP_SEQ)  
select 
    t5.GROUP_SEQ
from
(
     select 
        t1.GROUP_SEQ
        ,   t1.GROUP_NAME
        ,   t1.DIAG_KIND
        ,   t2.DIAG_TYPE
        ,   t1.COMP_SEQ
        ,   t2.COMP_NAME
        ,   t1.UPPER_SEQ
        ,   t1.GROUP_ID
     from dbo.T_VULN_GROUP as t1 with(nolock)
        inner join
        (
            select 
                COMP_SEQ
                ,   COMP_NAME
                ,   DIAG_TYPE
            from dbo.T_COMP_INFO
        ) as t2
        on
        (
            t1.COMP_SEQ = t2.COMP_SEQ
        )
) as t5
where t5.UPPER_SEQ <> 0

'
    set @subquery = 
'
select  
    @p_value = count(*) 
from @T_TEMP

select 
    t3.*
from 
(
    select 
        t1.GROUP_SEQ
        ,   t1.GROUP_NAME
        ,   t1.DIAG_KIND
        ,   t1.GROUP_ID
        ,   t1.DIAG_TOOL
        ,   t1.CREATE_DT
        ,   t1.COMP_SEQ
        ,   t1.DIAG_KIND as DIAG_KIND_NAME
        ,   t1.DIAG_TOOL as DIAG_TOOL_NAME
    from dbo.T_VULN_GROUP as t1 with(nolock)
    where UPPER_SEQ <> 0
) as t3
inner join @T_TEMP as t4
on
(
    t3.GROUP_SEQ = t4.GROUP_SEQ
)
'
    set @subquery = @subquery + ' where t4.TEMP_SEQ >= @fromidx and t4.TEMP_SEQ <= @toidx '     
    set @SQLString = @SQLString + @wheredata + @orderby + @subquery

    declare @params nvarchar(200)
    set   @params  ='@p_value int output , @toidx int, @fromidx int'
    
    exec sp_executesql  @SQLString
                      , @params
                      , @p_value = @allCount OUTPUT
                      , @fromidx = @fromidx
                      , @toidx = @toidx
                  
    select @allCount as TotCnt
end

GO
/****** Object:  StoredProcedure [dbo].[SP_VULN_INFO_INS]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SP_VULN_INFO_INS]
    @gubun NVARCHAR(32)
    , @diag_type NVARCHAR(32)
    , @comp_seq BIGINT
    , @vuln_seq BIGINT
    , @cur_group_seq BIGINT
    , @new_group_seq BIGINT
    , @cur_sort_index BIGINT
    , @new_sort_index BIGINT
    , @manual_yn int
    , @auto_yn int
    , @vuln_name nvarchar(128)
    , @rate int
    , @score int
    , @apply_time nvarchar(2)
    , @detail text
    , @detail_path nvarchar(256)
    , @overview nvarchar(2048)
	, @judgement nvarchar(2048)
    , @effect nvarchar(2048)
    , @remedy text
    , @remedy_path nvarchar(2048)
    , @remedy_detail text
    , @apply_target nvarchar(1024)
    , @use_yn int
    , @user_id nvarchar(16)
    , @manage_id nvarchar(32)
    , @client_standard_id nvarchar(32)

as

set nocount on

declare @v_rtn int
        , @rule_yn int
        , @max_vuln_seq bigint
        , @max_sort_index bigint
		, @vuln_count bigint

begin
    begin tran
    
    set @max_vuln_seq = (select isnull(MAX(VULN_SEQ), 0) + 1 from dbo.T_VULN with(nolock))

    set @v_rtn = -1
    
    if(@diag_type = 'WEB_VULN') begin
        set @rule_yn = 1
    end
    else begin
        set @rule_yn = 0
    end
    
    if('' = @detail_path or '' = ISNULL(@detail_path, '')) begin
        set @detail_path = null
    end

    if('' = @remedy_path or '' = ISNULL(@remedy_path, '')) begin
        set @remedy_path = null
    end
    
    if(@gubun = 'c') begin
        if('0' = @new_sort_index) begin
			set @vuln_count = (select count(*) from dbo.T_VULN where GROUP_SEQ = @new_group_seq)

			if(1 > @vuln_count) begin
				set @max_sort_index = 1
			end
			else begin
				set @max_sort_index = (
					select top 1 
						SORT_ORDER + 1 as MAX_SORT_ORDER
					from dbo.T_VULN
					where GROUP_SEQ = @new_group_seq
					order by SORT_ORDER desc)
			end
        end
        else begin
            set @max_sort_index = @new_sort_index
        end
                
        UPDATE dbo.T_VULN SET
            SORT_ORDER = SORT_ORDER + 1
        WHERE SORT_ORDER > @max_sort_index - 1
        and GROUP_SEQ = @new_group_seq
        
        insert into dbo.T_VULN
               (  
                    GROUP_SEQ
                    ,  MANUAL_YN
                    ,  AUTO_YN
                    ,  MANAGE_ID
                    ,  CLIENT_STANDARD_ID
                    ,  VULN_NAME
                    ,  SORT_ORDER
                    ,  RULE_YN
                    ,  RATE
                    ,  SCORE
                    ,  APPLY_TIME
                    ,  DETAIL
                    ,  DETAIL_PATH
					,  OVERVIEW
                    ,  JUDGEMENT
                    ,  EFFECT
                    ,  REMEDY
                    ,  REMEDY_PATH
                    ,  REMEDY_DETAIL
                    --,  REFRRENCE
                    --,  PARSER_CONTENTS
                    ,  APPLY_TARGET
                    ,  USE_YN
                    ,  EXCEPT_CD
                    --,  EXCEPT_TERM_TYPE
                    --,  EXCEPT_TERM_FR
                    --,  EXCEPT_TERM_TO
                    --,  EXCEPT_REASON
                    --,  EXCEPT_USER_ID
                    --,  EXCEPT_DT
                    ,  CREATE_USER_ID
                    ,  CREATE_DT
                    --,  UPDATE_USER_ID
                    --,  UPDATE_DT
		       )
         values
               (
                    @new_group_seq
                    ,  @manual_yn
                    ,  @auto_yn
                    ,  @manage_id
                    ,  @client_standard_id
                    ,  @vuln_name
                    ,  @max_sort_index
                    ,  @rule_yn
                    ,  @rate
                    ,  @score
                    ,  @apply_time
                    ,  @detail
                    ,  ''--@detail_path
					,  @overview
                    ,  @judgement
                    ,  @effect
                    ,  @remedy
                    ,  ''--@remedy_path
                    ,  @remedy_detail
                    --,  REFRRENCE
                    --,  PARSER_CONTENTS
                    ,  ''
                    ,  1
                    ,  0
                    --,  EXCEPT_TERM_TYPE
                    --,  EXCEPT_TERM_FR
                    --,  EXCEPT_TERM_TO
                    --,  EXCEPT_REASON
                    --,  EXCEPT_USER_ID
                    --,  EXCEPT_DT
                    ,  @user_id
                    ,  GETDATE()
                    --,  UPDATE_USER_ID
                    --,  UPDATE_DT
               )
    end
    
    set @v_rtn = 1
    if (@@error <> 0)
        begin
           rollback tran
           set @v_rtn = -1
        end
    commit tran  
    return @v_rtn
end
GO
/****** Object:  StoredProcedure [dbo].[SP_VULN_INFO_INS_WITH_RTN]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[SP_VULN_INFO_INS_WITH_RTN]
    @gubun NVARCHAR(32)
    , @diag_type NVARCHAR(32)
    , @comp_seq BIGINT
    , @vuln_seq BIGINT
    , @cur_group_seq BIGINT
    , @new_group_seq BIGINT
    , @cur_sort_index BIGINT
    , @new_sort_index BIGINT
    , @manual_yn int
    , @auto_yn int
    , @vuln_name nvarchar(128)
    , @rate int
    , @score int
    , @apply_time nvarchar(2)
    , @detail text
    , @detail_path nvarchar(256)
    , @overview nvarchar(2048)
	, @judgement nvarchar(2048)
    , @effect nvarchar(2048)
    , @remedy text
    , @remedy_path nvarchar(2048)
    , @remedy_detail text
    , @apply_target nvarchar(1024)
    , @use_yn int
    , @user_id nvarchar(16)
    , @manage_id nvarchar(32)
    , @client_standard_id nvarchar(32)
	, @rtn_message nvarchar(128) output

as

set nocount on

declare @rule_yn int
        , @max_vuln_seq bigint
        , @max_sort_index bigint
		, @vuln_count bigint

begin
	begin try
		begin tran
			set @rtn_message = 'NONE'
    
			set @max_vuln_seq = (select isnull(MAX(VULN_SEQ), 0) + 1 from dbo.T_VULN with(nolock))

			if(@diag_type = 'WEB_VULN') begin
				set @rule_yn = 1
			end
			else begin
				set @rule_yn = 0
			end
    
			if('' = @detail_path or '' = ISNULL(@detail_path, '')) begin
				set @detail_path = null
			end

			if('' = @remedy_path or '' = ISNULL(@remedy_path, '')) begin
				set @remedy_path = null
			end
    
	
			if(@gubun = 'c') begin
				if('0' = @new_sort_index) begin
					set @vuln_count = (select count(*) from dbo.T_VULN where GROUP_SEQ = @new_group_seq)

					if(1 > @vuln_count) begin
						set @max_sort_index = 1
					end
					else begin
						set @max_sort_index = (
							select top 1 
								SORT_ORDER + 1 as MAX_SORT_ORDER
							from dbo.T_VULN
							where GROUP_SEQ = @new_group_seq
							order by SORT_ORDER desc)
					end
				end
				else begin
					set @max_sort_index = @new_sort_index
				end
                
				UPDATE dbo.T_VULN SET
					SORT_ORDER = SORT_ORDER + 1
				WHERE SORT_ORDER > @max_sort_index - 1
				and GROUP_SEQ = @new_group_seq
        
				insert into dbo.T_VULN
				(  
					GROUP_SEQ
					,  MANUAL_YN
					,  AUTO_YN
					,  MANAGE_ID
					,  CLIENT_STANDARD_ID
					,  VULN_NAME
					,  SORT_ORDER
					,  RULE_YN
					,  RATE
					,  SCORE
					,  APPLY_TIME
					,  DETAIL
					,  DETAIL_PATH
					,  OVERVIEW
					,  JUDGEMENT
					,  EFFECT
					,  REMEDY
					,  REMEDY_PATH
					,  REMEDY_DETAIL
					--,  REFRRENCE
					--,  PARSER_CONTENTS
					,  APPLY_TARGET
					,  USE_YN
					,  EXCEPT_CD
					--,  EXCEPT_TERM_TYPE
					--,  EXCEPT_TERM_FR
					--,  EXCEPT_TERM_TO
					--,  EXCEPT_REASON
					--,  EXCEPT_USER_ID
					--,  EXCEPT_DT
					,  CREATE_USER_ID
					,  CREATE_DT
					--,  UPDATE_USER_ID
					--,  UPDATE_DT
				)
				values
				(
					@new_group_seq
					,  @manual_yn
					,  @auto_yn
					,  @manage_id
					,  @client_standard_id
					,  @vuln_name
					,  @max_sort_index
					,  @rule_yn
					,  @rate
					,  @score
					,  @apply_time
					,  @detail
					,  ''--@detail_path
					,  @overview
					,  @judgement
					,  @effect
					,  @remedy
					,  ''--@remedy_path
					,  @remedy_detail
					--,  REFRRENCE
					--,  PARSER_CONTENTS
					,  ''
					,  1
					,  0
					--,  EXCEPT_TERM_TYPE
					--,  EXCEPT_TERM_FR
					--,  EXCEPT_TERM_TO
					--,  EXCEPT_REASON
					--,  EXCEPT_USER_ID
					--,  EXCEPT_DT
					,  @user_id
					,  GETDATE()
					--,  UPDATE_USER_ID
					--,  UPDATE_DT
				)
			end
    
			set @rtn_message = 'OK'

		commit tran
	end try
	begin catch
		if (@@TRANCOUNT <> 0) begin
			rollback tran
			-- 리턴 메세지
			SET @rtn_message = 'Error Line :' + CAST(ERROR_LINE() AS VARCHAR) + ' ' +CAST(ERROR_NUMBER() AS VARCHAR) + ' ' + ISNULL(ERROR_PROCEDURE(),'없음')
			-- 에러 프로세스
            DECLARE @v          NVARCHAR(50)
            DECLARE @Name       NVARCHAR(50) = CAST(ERROR_PROCEDURE() AS VARCHAR)
            DECLARE @Line       NVARCHAR(10) = CAST(ERROR_LINE() AS VARCHAR)
            DECLARE @Number     NVARCHAR(10) = CAST(ERROR_NUMBER() AS VARCHAR)
            DECLARE @Date       DATETIME = GETDATE()
            --EXEC uspDBErrorInsert 'INSERT', -1, @Name, @Line, @Number, @Date, '', @v OUTPUT
		end
	end catch

	return
end
GO
/****** Object:  StoredProcedure [dbo].[SP_VULN_INFO_UPT_WITH_RTN]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_VULN_INFO_UPT_WITH_RTN]
     @gubun NVARCHAR(32)
    , @diag_type NVARCHAR(32)
    , @comp_seq BIGINT
    , @vuln_seq BIGINT
    , @cur_group_seq BIGINT
    , @new_group_seq BIGINT
    , @cur_sort_index BIGINT
    , @new_sort_index BIGINT
    , @manual_yn int
    , @auto_yn int
    , @vuln_name nvarchar(128)
    , @rate int
    , @score int
    , @apply_time nvarchar(2)
    , @detail text
    , @detail_path nvarchar(256)
    , @overview nvarchar(2048)
    , @judgement nvarchar(2048)
    , @effect nvarchar(2048)
    , @remedy text
    , @remedy_path nvarchar(2048)
    , @remedy_detail text
    , @apply_target nvarchar(1024)
    , @use_yn int
    , @user_id nvarchar(16)
    , @manage_id nvarchar(32)
    , @client_standard_id nvarchar(32)
    , @rtn_message nvarchar(128) output
as

set nocount on

declare @rule_yn int
        , @max_vuln_seq bigint
        , @max_sort_index bigint
        
begin
	begin try
		begin tran
			set @rtn_message = 'NONE'
			
			set @max_vuln_seq = (select isnull(max(GROUP_SEQ), 0) + 1 from dbo.T_VULN_GROUP with(nolock))

			if(@diag_type = 'WEB_VULN') begin
				set @rule_yn = 'Y'
			end
			else begin
				set @rule_yn = 'N'
			end
	        
			if('' = @detail_path or '' = isnull(@detail_path, '')) begin
				set @detail_path = null
			end

			if('' = @remedy_path or '' = isnull(@remedy_path, '')) begin
				set @remedy_path = null
			end
	        
			if(@gubun = 'm') begin
				if(@cur_group_seq = @new_group_seq) begin
					if(@new_sort_index > @cur_sort_index) begin
						update dbo.T_VULN set
							SORT_ORDER = SORT_ORDER - 1
						where SORT_ORDER > @cur_sort_index and @new_sort_index + 1 > SORT_ORDER
						and GROUP_SEQ = @cur_group_seq					
						set @max_sort_index = @new_sort_index
					end
					else if(@cur_sort_index > @new_sort_index) begin
						update dbo.T_VULN set
							SORT_ORDER = SORT_ORDER + 1
						where SORT_ORDER > @new_sort_index - 1 and @cur_sort_index > SORT_ORDER
						and GROUP_SEQ = @new_group_seq					
						set @max_sort_index = @new_sort_index
					end
					else begin					
						set @max_sort_index = @new_sort_index
					end
				end
				else if(@cur_group_seq <> @new_group_seq) begin
					if('0' = @new_sort_index) begin
						set @max_sort_index = (
						select top 1 
							SORT_ORDER + 1 as MAX_SORT_ORDER
						from dbo.T_VULN
						where GROUP_SEQ = @new_group_seq
						order by SORT_ORDER desc)
					end
					else begin
						set @max_sort_index = @new_sort_index
					end
	                
					update dbo.T_VULN set
						SORT_ORDER = SORT_ORDER - 1
					where SORT_ORDER > @cur_sort_index
					and GROUP_SEQ = @cur_group_seq
	                
					update dbo.T_VULN set
						SORT_ORDER = SORT_ORDER + 1
					where SORT_ORDER > @max_sort_index - 1
					and GROUP_SEQ = @new_group_seq
				end
	            
				update dbo.T_VULN
				set
					GROUP_SEQ = @new_group_seq
					,   MANUAL_YN = @manual_yn
					,   AUTO_YN = @auto_yn
					,   MANAGE_ID = @manage_id
					,   CLIENT_STANDARD_ID = @client_standard_id
					,   VULN_NAME = @vuln_name
					,   SORT_ORDER = @max_sort_index
					--,   RULE_YN = @rule_yn
					,   RATE = @rate
					,   SCORE = @score
					,   APPLY_TIME = @apply_time
					,   DETAIL = @detail
					,   DETAIL_PATH = @detail_path
					,   OVERVIEW = @overview
					,   JUDGEMENT = @judgement
					,   EFFECT = @effect
					,   REMEDY = @remedy
					,   REMEDY_PATH = @remedy_path
					,	REMEDY_DETAIL = @remedy_detail
					--,   REFRRENCE = ''
					--,   PARSER_CONTENTS = null
					--,   APPLY_TARGET = @apply_target
					--,   USE_YN = @use_yn
					--,   EXCEPT_CD
					--,   EXCEPT_TERM_TYPE
					--,   EXCEPT_TERM_FR
					--,   EXCEPT_TERM_TO
					--,   EXCEPT_REASON
					--,   EXCEPT_USER_ID
					--,   EXCEPT_DT
					--,   CREATE_USER_ID
					--,   CREATE_DT
					,   UPDATE_USER_ID = @user_id
					,   UPDATE_DT = getdate()
				where VULN_SEQ = @vuln_seq

			end
			else begin
				update dbo.T_VULN
				set
					AUTO_YN = @auto_yn
					,   MANUAL_YN = @manual_yn
					,   MANAGE_ID = @manage_id
					,	GROUP_SEQ = @new_group_seq
					,   CLIENT_STANDARD_ID = @client_standard_id
					,   VULN_NAME = @vuln_name
					,   RATE = @rate
					,   SCORE = @score
					,   APPLY_TIME = @apply_time
					,   OVERVIEW = @overview
					,   JUDGEMENT = @judgement
					,   EFFECT = @effect
					,   REMEDY = @remedy
					,	REMEDY_DETAIL = @remedy_detail
					,   UPDATE_DT = getdate()
					,   UPDATE_USER_ID = @user_id
					,   DETAIL = @detail 
				where VULN_SEQ = @vuln_seq
				--and GROUP_SEQ = @new_group_seq

			end
			
			set @rtn_message = 'OK'
			
		commit tran
	end try
	begin catch
		if (@@TRANCOUNT <> 0) begin
			rollback tran
			-- 리턴 메세지
			SET @rtn_message = 'Error Line :' + CAST(ERROR_LINE() AS VARCHAR) + ' ' +CAST(ERROR_NUMBER() AS VARCHAR) + ' ' + ISNULL(ERROR_PROCEDURE(),'없음')
			-- 에러 프로세스
            DECLARE @v          NVARCHAR(50)
            DECLARE @Name       NVARCHAR(50) = CAST(ERROR_PROCEDURE() AS VARCHAR)
            DECLARE @Line       NVARCHAR(10) = CAST(ERROR_LINE() AS VARCHAR)
            DECLARE @Number     NVARCHAR(10) = CAST(ERROR_NUMBER() AS VARCHAR)
            DECLARE @Date       DATETIME = GETDATE()
            --EXEC uspDBErrorInsert 'INSERT', -1, @Name, @Line, @Number, @Date, '', @v OUTPUT
		end
	end catch
	
    return
end

GO
/****** Object:  StoredProcedure [dbo].[SP_VULN_INFO_VIW]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_VULN_INFO_VIW]
    @vuln_seq bigint
    ,   @comp_seq bigint
    ,   @diag_kind nvarchar(32)
    ,   @group_seq bigint
as

set transaction isolation level read uncommitted
set nocount on

begin
    declare
		@_comp_seq      bigint = 0
		, @_group_seq   bigint = 0
		, @_vuln_seq    bigint = 0

    if @vuln_seq is null or @vuln_seq = '' begin
		set @vuln_seq = null
    end

    if @comp_seq is null or @comp_seq = '' begin
		set @comp_seq = null
    end
    
    if @diag_kind is null or @diag_kind = '' or @diag_kind = '0' begin
		set @diag_kind = null
    end

    if @group_seq is null or @group_seq = '' begin
		set @group_seq = null
    end
    
	select
		t12.DIAG_TYPE  
		, t12.DIAG_KIND  
		, t12.COMP_SEQ
		, t12.COMP_NAME
		, t12.GROUP_SEQ
		, t12.GROUP_NAME
		, t33.APPLY_TARGET
		, t33.APPLY_TIME
		, t33.AUTO_YN
		, t33.CLIENT_STANDARD_ID
		, t33.CREATE_DT
		, t33.CREATE_USER_ID
		, t33.DETAIL
		, t33.DETAIL_PATH
		, t33.EFFECT
		, t33.EXCEPT_CD
		, t33.EXCEPT_DT
		, t33.EXCEPT_REASON
		, t33.EXCEPT_TERM_FR
		, t33.EXCEPT_TERM_TO
		, t33.EXCEPT_TERM_TYPE
		, t33.EXCEPT_USER_ID
		, t33.JUDGEMENT
		, t33.MANAGE_ID
		, t33.MANAGEMENT_VULN_YN
		, t33.MANUAL_YN
		, t33.ORG_PARSER_CONTENTS
		, t33.OVERVIEW
		, t33.PARSER_CONTENTS
		, t33.RATE
		, t33.REFRRENCE
		, t33.REMEDY
		, t33.REMEDY_DETAIL
		, t33.REMEDY_PATH
		, t33.RULE_YN
		, t33.SCORE
		, t33.SORT_ORDER
		, t33.UPDATE_DT
		, t33.UPDATE_USER_ID
		, t33.USE_YN
		, t33.VULGROUP
		, t33.VULN_NAME
		, t33.VULN_SEQ
		, t33.VULNO
	from dbo.T_VULN as t33
	left outer join
	(
		select
			t11.COMP_SEQ
			, t11.COMP_NAME
			, t11.DIAG_TYPE
			--, (select CodeName from dbo.TCommonCode where CodeType = 'DIAG_TYPE' and CodeId = t11.DIAG_TYPE)
			, t22.DIAG_KIND
			, t22.GROUP_SEQ
			, t22.GROUP_NAME
		from
		(
			select
				t1.COMP_SEQ
				, t1.COMP_NAME
				, t1.DIAG_TYPE
			from dbo.T_COMP_INFO as t1 with(nolock)
			where 1=1
			and case when @comp_seq is null then '1' else t1.COMP_SEQ end = case when @comp_seq is null then '1' else @_comp_seq end
		) as t11
		left outer join
		(
			select
				t2.COMP_SEQ
				, t2.DIAG_KIND
				, t2.GROUP_NAME
				, t2.GROUP_SEQ
			from dbo.T_VULN_GROUP as t2 with(nolock)
			where 1=1
			and GROUP_TYPE = 'G'
			and case when @group_seq is null then '1' else t2.GROUP_SEQ end = case when @group_seq is null then '1' else @_group_seq end
			and case when @diag_kind is null then '1' else t2.DIAG_KIND end = case when @diag_kind is null then '1' else @diag_kind end
		) as t22
		on
		(
			t11.COMP_SEQ = t22.COMP_SEQ
		)
	) as t12
	on
	(
		t12.GROUP_SEQ = t33.GROUP_SEQ
	)
	where case when @vuln_seq is null then '1' else t33.VULN_SEQ end =  case when @vuln_seq is null then '1' else @_vuln_seq end
    
end
GO
/****** Object:  StoredProcedure [dbo].[SP_VULN_LIST]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[SP_VULN_LIST]
    @gubun				nvarchar(8)
    ,   @diag_type      nvarchar(32)
    ,   @diag_kind      nvarchar(32)
	,	@comp_seq		bigint
    ,   @comp_name		nvarchar(128)
	,	@group_seq		bigint
	,	@group_name		nvarchar(18)
	,	@vuln_seq		bigint
	,	@vuln_name		nvarchar(128)
	,	@manage_id		nvarchar(128)
	,	@rate			int
	,	@score			int
	,	@use_yn			int
	,	@exception_yn	int
	,   @user_id		nvarchar(16)
	,   @sort_field		nvarchar(50)
    ,   @is_desc		tinyint = 1
	,   @pagesize		int
    ,   @pageindex		int
    ,   @allCount		bigint output
as
	
set transaction isolation level read uncommitted
set nocount on

begin
    declare  
        @SQLString      nvarchar(max) = ''
        ,   @wheredata  nvarchar(max) = ''
        ,   @orderby    varchar(500) = ' order by DIAG_TYPE, DIAG_KIND, MANAGE_ID asc'
        ,   @subquery   varchar(max) = ''
        ,	@is_desc_title varchar(10)   = ''


	if 'all' = @gubun or '' = @gubun or '' = isnull(@gubun, '') begin
        set @gubun = null;
    end

	if 'all' = @diag_type or '' = @diag_type or '' = isnull(@diag_type, '') begin
		set @diag_type = null;
    end

    if 'all' = @diag_kind or '' = @diag_kind or '' = isnull(@diag_kind, '') begin
		set @diag_kind = null;
    end

    if 1 > @comp_seq begin
        set @comp_seq = null;
    end

    if '' = @comp_name or '' = isnull(@comp_name, '') begin
        set @comp_name = null;
    end

	if 1 > @group_seq begin
		set @group_seq = null;
	end

    if '' = @group_name or '' = isnull(@group_name, '') begin
        set @group_name = null;
    end

	if 1 > @vuln_seq begin
		set @vuln_seq = null;
	end

    if '' = @vuln_name or '' = isnull(@vuln_name, '') begin
        set @vuln_name = null;
    end

	if '' = @manage_id or '' = isnull(@manage_id, '') begin
        set @manage_id = null;
    end

	if 1 > @rate begin
		set @rate = null;
	end

	if 1 > @score begin
		set @score = null;
	end

	if 1 > @use_yn begin
		set @use_yn = null;
    end

	if 1 > @exception_yn begin
		set @exception_yn = null;
    end

    if(@comp_seq is not null) begin
	    set @wheredata =  @wheredata + ' and COMP_SEQ = ''' + @comp_seq + ''' '
    end

    if(@diag_type is not null) begin
	    set @wheredata =  @wheredata + ' and DIAG_TYPE = ''' + @diag_type + ''' '
    end

    if(@diag_kind is not null) begin
	    set @wheredata =  @wheredata + ' and DIAG_KIND = ''' + @diag_kind + ''' '
    end
    
    if(@vuln_name is not null) begin
	    set @wheredata =  @wheredata + ' and VULN_NAME like ''%' + @vuln_name + '%'' '
    end

    if(@group_name is not null) begin
	    set @wheredata =  @wheredata + ' and GROUP_NAME like ''%' + @group_name + '%'' '
    end
    
    if '' = @sort_field or '' = isnull(@sort_field, '') begin
        set @orderby = ' order by VULN_SEQ asc '
    end
    else begin
        if 1 = @is_desc begin
           set @is_desc_title = 'DESC'
        end
        else begin
           set @is_desc_title = 'ASC'
        end

        set @orderby = ' order by ' + @sort_field + ' ' + @is_desc_title
    end

    declare @fromidx int
    declare @toidx   int
    set @fromidx = ((@pageindex - 1) * @pagesize) + 1
    set @toidx = @pageindex * @pagesize

    set @SQLString = ' 
declare @T_TEMP table 
(
    TEMP_SEQ 	    bigint identity primary key
    ,   VULN_SEQ   bigint
)

insert into @T_TEMP(VULN_SEQ)  
select
	VULN_SEQ
from
(
	select
		t1.*
		, t2.COMP_NAME
		, t2.COMP_SEQ
		, t2.DIAG_KIND
		, t2.DIAG_TYPE
		, t2.GROUP_NAME
		, t2.[LEVEL]
	from dbo.T_VULN as t1 with(nolock)
	left outer join
	(
		select
			t21.GROUP_SEQ
			, t21.GROUP_NAME
			, t21.DIAG_KIND
			, t21.[LEVEL]
			, t22.DIAG_TYPE
			, t22.COMP_NAME
			, t22.COMP_SEQ
		from dbo.T_VULN_GROUP as t21 with(nolock)
		left outer join
		(
			select
				COMP_SEQ
				, COMP_NAME
				, DIAG_TYPE
			from dbo.T_COMP_INFO with(nolock)
		) as t22
		on
		(
			t21.COMP_SEQ = t22.COMP_SEQ
		)
	) as t2
	on
	(
		t1.GROUP_SEQ = t2.GROUP_SEQ
	)
) as t0
where 1=1

'
    set @subquery = 
'
select  
    @p_value = count(*) 
from @T_TEMP

select 
    t3.*
from 
(
    select 
        *
    from dbo.T_VULN with(nolock)
) as t3
inner join @T_TEMP as t4
on
(
    t3.VULN_SEQ = t4.VULN_SEQ
)
'
    set @subquery = @subquery + ' where t4.TEMP_SEQ >= @fromidx and t4.TEMP_SEQ <= @toidx '     
    set @SQLString = @SQLString + @wheredata + @orderby + @subquery

    declare @params nvarchar(200)
    set   @params  ='@p_value int output , @toidx int, @fromidx int'
    print cast(@SQLString as ntext)
    exec sp_executesql  @SQLString
                      , @params
                      , @p_value = @allCount OUTPUT
                      , @fromidx = @fromidx
                      , @toidx = @toidx
                  
    select @allCount as TotCnt
end



GO
/****** Object:  StoredProcedure [dbo].[SP_VULN_LIST_02]    Script Date: 2018-12-13 오후 10:06:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE procedure [dbo].[SP_VULN_LIST_02]
    @gubun				nvarchar(8)
    ,   @diag_type      nvarchar(32)
    ,   @diag_kind      nvarchar(32)
	,	@comp_seq		bigint
    ,   @comp_name		nvarchar(128)
	,	@group_seq		bigint
	,	@group_name		nvarchar(18)
	,	@vuln_seq		bigint
	,	@vuln_name		nvarchar(128)
	,	@manage_id		nvarchar(128)
	,	@rate			int
	,	@score			int
	,	@use_yn			int
	,	@exception_yn	int
	,   @user_id		nvarchar(16)
	,   @sort_field		nvarchar(50)
    ,   @is_desc		tinyint = 1
	,   @pagesize		int
    ,   @pageindex		int
    ,   @allCount		bigint output
as
	
set transaction isolation level read uncommitted
set nocount on

begin
    declare  
        @SQLString      nvarchar(max) = ''
        ,   @wheredata  nvarchar(max) = ''
        ,   @orderby    varchar(500) = ' order by CREATE_DT desc'
        ,   @subquery   varchar(max) = ''
        ,	@is_desc_title varchar(10)   = ''


	if 'all' = @gubun or '' = @gubun or '' = isnull(@gubun, '') begin
        set @gubun = null;
    end

	if 'all' = @diag_type or '' = @diag_type or '' = isnull(@diag_type, '') begin
		set @diag_type = null;
    end

    if 'all' = @diag_kind or '' = @diag_kind or '' = isnull(@diag_kind, '') begin
		set @diag_kind = null;
    end

    if 1 > @comp_seq begin
        set @comp_seq = null;
    end

    if '' = @comp_name or '' = isnull(@comp_name, '') begin
        set @comp_name = null;
    end

	if 1 > @group_seq begin
		set @group_seq = null;
	end

    if '' = @group_name or '' = isnull(@group_name, '') begin
        set @group_name = null;
    end

	if 1 > @vuln_seq begin
		set @vuln_seq = null;
	end

    if '' = @vuln_name or '' = isnull(@vuln_name, '') begin
        set @vuln_name = null;
    end

	if '' = @manage_id or '' = isnull(@manage_id, '') begin
        set @manage_id = null;
    end

	if 1 > @rate begin
		set @rate = null;
	end

	if 1 > @score begin
		set @score = null;
	end

	if 1 > @score begin
		set @use_yn = null;
    end

	if 1 > @exception_yn begin
		set @exception_yn = null;
    end

    if(@comp_seq is not null) begin
	    set @wheredata =  @wheredata + ' and COMP_SEQ = ''' + @comp_seq + ''' '
    end

    if(@diag_type is not null) begin
	    set @wheredata =  @wheredata + ' and DIAG_TYPE = ''' + @diag_type + ''' '
    end

    if(@diag_kind is not null) begin
	    set @wheredata =  @wheredata + ' and DIAG_KIND = ''' + @diag_kind + ''' '
    end
    
    if(@vuln_name is not null) begin
	    set @wheredata =  @wheredata + ' and VULN_NAME like ''%' + @vuln_name + '%'' '
    end

    if(@group_name is not null) begin
	    set @wheredata =  @wheredata + ' and GROUP_NAME like ''%' + @group_name + '%'' '
    end
    
    if '' = @sort_field or '' = isnull(@sort_field, '') begin
        set @orderby = ' order by CREATE_DT desc '
    end
    else begin
        if 1 = @is_desc begin
           set @is_desc_title = 'DESC'
        end
        else begin
           set @is_desc_title = 'ASC'
        end

        set @orderby = ' order by ' + @sort_field + ' ' + @is_desc_title
    end

    declare @fromidx int
    declare @toidx   int
    set @fromidx = ((@pageindex - 1) * @pagesize) + 1
    set @toidx = @pageindex * @pagesize

    set @SQLString = ' 
declare @T_TEMP table 
(
    TEMP_SEQ 	    bigint identity primary key
    ,   VULN_SEQ   bigint
)

insert into @T_TEMP(VULN_SEQ)  
select
	VULN_SEQ
from
(
	select
		t1.*
		, t2.COMP_NAME
		, t2.COMP_SEQ
		, t2.DIAG_KIND
		, t2.DIAG_TYPE
		, t2.GROUP_NAME
		, t2.[LEVEL]
	from dbo.T_VULN as t1 with(nolock)
	left outer join
	(
		select
			t21.GROUP_SEQ
			, t21.GROUP_NAME
			, t21.DIAG_KIND
			, t21.[LEVEL]
			, t22.DIAG_TYPE
			, t22.COMP_NAME
			, t22.COMP_SEQ
		from dbo.T_VULN_GROUP as t21 with(nolock)
		left outer join
		(
			select
				COMP_SEQ
				, COMP_NAME
				, DIAG_TYPE
			from dbo.T_COMP_INFO with(nolock)
		) as t22
		on
		(
			t21.COMP_SEQ = t22.COMP_SEQ
		)
	) as t2
	on
	(
		t1.GROUP_SEQ = t2.GROUP_SEQ
	)
) as t0
where 1=1

'
    set @subquery = 
'
select  
    @p_value = count(*) 
from @T_TEMP

select 
    t3.APPLY_TARGET
	, t3.APPLY_TIME
	, t3.AUTO_YN
	, t3.CLIENT_STANDARD_ID
	, t3.CREATE_DT
	, t3.CREATE_USER_ID
	, t3.DETAIL
	, t3.DETAIL_PATH
	, t3.EFFECT
	, t3.EXCEPT_CD
	, t3.EXCEPT_DT
	, t3.EXCEPT_REASON
	, t3.EXCEPT_TERM_FR
	, t3.EXCEPT_TERM_TO
	, t3.EXCEPT_TERM_TYPE
	, t3.EXCEPT_USER_ID
	, t3.GROUP_SEQ
	, t3.JUDGEMENT
	, t3.MANAGE_ID
	, t3.MANAGEMENT_VULN_YN
	, t3.MANUAL_YN
	, t3.ORG_PARSER_CONTENTS
	, t3.OVERVIEW
	, t3.RATE
	, t3.PARSER_CONTENTS
	, t3.REFRRENCE
	, t3.REMEDY
	, t3.REMEDY_DETAIL
	, t3.REMEDY_PATH
	, t3.RULE_YN
	, t3.SCORE
	, t3.SORT_ORDER
	, t3.UPDATE_DT
	, t3.UPDATE_USER_ID
	, t3.USE_YN
	, t3.VULGROUP
	, t3.VULN_NAME
	, t3.VULN_SEQ
	, t3.VULNO
	, t4.TEMP_SEQ
from 
(
    select 
        *
    from dbo.T_VULN with(nolock)
) as t3
inner join @T_TEMP as t4
on
(
    t3.VULN_SEQ = t4.VULN_SEQ
)
'
    set @subquery = @subquery + ' where t4.TEMP_SEQ >= @fromidx and t4.TEMP_SEQ <= @toidx '     
    set @SQLString = @SQLString + @wheredata + @orderby + @subquery

    declare @params nvarchar(200)
    set   @params  ='@p_value int output , @toidx int, @fromidx int'
    
    exec sp_executesql  @SQLString
                      , @params
                      , @p_value = @allCount OUTPUT
                      , @fromidx = @fromidx
                      , @toidx = @toidx
                  
    select @allCount as TotCnt
end



GO


USE [MANAGEAPP]
GO

/****** Object:  StoredProcedure [dbo].[SP_VULN_INFO_VIW]    Script Date: 2018-12-14 오전 12:15:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[SP_VULN_INFO_VIW]
    @vuln_seq bigint
    ,   @comp_seq bigint
    ,   @diag_kind nvarchar(32)
    ,   @group_seq bigint
as

set transaction isolation level read uncommitted
set nocount on

begin
    declare
		@_comp_seq      bigint = 0
		, @_group_seq   bigint = 0
		, @_vuln_seq    bigint = 0

    if 1 > @vuln_seq begin
		set @vuln_seq = null
    end

    if 1 > @comp_seq begin
		set @comp_seq = null
    end
    
    if @diag_kind is null or @diag_kind = '' or @diag_kind = '0' begin
		set @diag_kind = null
    end

    if 1 > @group_seq begin
		set @group_seq = null
    end
    
	select
		t12.DIAG_TYPE  
		, t12.DIAG_KIND  
		, t12.COMP_SEQ
		, t12.COMP_NAME
		, t12.GROUP_SEQ
		, t12.GROUP_NAME
		, t33.APPLY_TARGET
		, t33.APPLY_TIME
		, t33.AUTO_YN
		, t33.CLIENT_STANDARD_ID
		, t33.CREATE_DT
		, t33.CREATE_USER_ID
		, t33.DETAIL
		, t33.DETAIL_PATH
		, t33.EFFECT
		, t33.EXCEPT_CD
		, t33.EXCEPT_DT
		, t33.EXCEPT_REASON
		, t33.EXCEPT_TERM_FR
		, t33.EXCEPT_TERM_TO
		, t33.EXCEPT_TERM_TYPE
		, t33.EXCEPT_USER_ID
		, t33.JUDGEMENT
		, t33.MANAGE_ID
		, t33.MANAGEMENT_VULN_YN
		, t33.MANUAL_YN
		, t33.ORG_PARSER_CONTENTS
		, t33.OVERVIEW
		, t33.PARSER_CONTENTS
		, t33.RATE
		, t33.REFRRENCE
		, t33.REMEDY
		, t33.REMEDY_DETAIL
		, t33.REMEDY_PATH
		, t33.RULE_YN
		, t33.SCORE
		, t33.SORT_ORDER
		, t33.UPDATE_DT
		, t33.UPDATE_USER_ID
		, t33.USE_YN
		, t33.VULGROUP
		, t33.VULN_NAME
		, t33.VULN_SEQ
		, t33.VULNO
	from dbo.T_VULN as t33
	left outer join
	(
		select
			t11.COMP_SEQ
			, t11.COMP_NAME
			, t11.DIAG_TYPE
			--, (select CodeName from dbo.TCommonCode where CodeType = 'DIAG_TYPE' and CodeId = t11.DIAG_TYPE)
			, t22.DIAG_KIND
			, t22.GROUP_SEQ
			, t22.GROUP_NAME
		from
		(
			select
				t1.COMP_SEQ
				, t1.COMP_NAME
				, t1.DIAG_TYPE
			from dbo.T_COMP_INFO as t1 with(nolock)
			where 1=1
			and case when @comp_seq is null then '1' else t1.COMP_SEQ end = case when @comp_seq is null then '1' else @comp_seq end
		) as t11
		left outer join
		(
			select
				t2.COMP_SEQ
				, t2.DIAG_KIND
				, t2.GROUP_NAME
				, t2.GROUP_SEQ
			from dbo.T_VULN_GROUP as t2 with(nolock)
			where 1=1
			and GROUP_TYPE = 'G'
			and case when @group_seq is null then '1' else t2.GROUP_SEQ end = case when @group_seq is null then '1' else @group_seq end
			and case when @diag_kind is null then '1' else t2.DIAG_KIND end = case when @diag_kind is null then '1' else @diag_kind end
		) as t22
		on
		(
			t11.COMP_SEQ = t22.COMP_SEQ
		)
	) as t12
	on
	(
		t12.GROUP_SEQ = t33.GROUP_SEQ
	)
	where case when @vuln_seq is null then '1' else t33.VULN_SEQ end =  case when @vuln_seq is null then '1' else @vuln_seq end
    
end
GO