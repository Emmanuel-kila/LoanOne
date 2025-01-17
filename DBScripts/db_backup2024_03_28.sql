PGDMP     2    .                |            loans    14.2    15.1 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16741    loans    DATABASE     �   CREATE DATABASE loans WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United Kingdom.1252';
    DROP DATABASE loans;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    4                       1255    28311 �   addeditperson(integer, smallint, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.addeditperson(_pid integer, _type_id smallint, _firstname character varying, _middlename character varying, _othername character varying, _email character varying, _phone character varying, _address character varying, _idnumber character varying, _nextofkin character varying, _income numeric, _uid integer, _mode character varying) RETURNS TABLE(new_id integer, message text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Initialize new_id and message variables
  new_id := NULL;
  message := '';

  -- Check if mode is valid
  IF _mode NOT IN ('1', '2') THEN
    message := 'Invalid mode';
    RETURN; -- Early exit for invalid mode
  END IF;

  -- Check if any required parameter is NULL
  IF _pid IS NULL OR _type_id IS NULL OR _firstname IS NULL OR _email IS NULL OR _dob IS NULL THEN
    message := 'Missing required parameter';
    RETURN;
  END IF;

  -- Insert or update data into the person table based on the mode
  BEGIN
    IF _mode = '1' THEN
      -- Insert new record
      INSERT INTO person (pid, type_id, firstname, middlename, othername, email, dob, phone, address, idnumber, nextofkin, income)
      VALUES (_pid, _type_id, _firstname, _middlename, _othername, _email, _dob, _phone, _address, _idnumber, _nextofkin, _income)
      RETURNING pid INTO new_id;
    ELSEIF _mode = '2' THEN
      -- Update existing record
      UPDATE person
      SET type_id = _type_id,
          firstname = _firstname,
          middlename = _middlename,
          othername = _othername,
          email = _email,
          dob = _dob,
          phone = _phone,
          address = _address,
          idnumber = _idnumber,
          nextofkin = _nextofkin,
          income = _income
      WHERE pid = _pid;
      -- Set new_id to the updated PID
      new_id := _pid;
    END IF;

    -- Consider adding specific exception handling within the block for informative messages

  EXCEPTION
    WHEN others THEN
      message := 'Error occurred while processing data';
      RETURN;
  END;

  -- Set message based on mode (moved outside the block)
  IF _mode = '1' THEN
    message := 'Data inserted successfully';
  ELSEIF _mode = '2' THEN
    message := 'Data updated successfully';
  END IF;

END;
$$;
 c  DROP FUNCTION public.addeditperson(_pid integer, _type_id smallint, _firstname character varying, _middlename character varying, _othername character varying, _email character varying, _phone character varying, _address character varying, _idnumber character varying, _nextofkin character varying, _income numeric, _uid integer, _mode character varying);
       public          postgres    false    4                       1255    28394    get_clients(integer)    FUNCTION       CREATE FUNCTION public.get_clients(_uid integer) RETURNS TABLE(pid integer, type_id smallint, firstname character varying, middlename character varying, othername character varying, email character varying, dob date, phone character varying, address character varying, idnumber character varying, nextofkin character varying, income numeric, created_by integer, createdon timestamp without time zone, modified_by integer, modifiedon timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
	
BEGIN

	DROP TABLE IF EXISTS tmp_clients;
	CREATE LOCAL TEMP TABLE  tmp_clients
	(
    pid 		integer,
    type_id 	smallint,
    firstname 	character varying(50) ,
    middlename 	character varying(50),
    othername 	character varying(50),
    email 		character varying(50),
    dob 		date,
    phone 		character varying(25),
    address 	character varying(100),
    idnumber 	character varying(20),
    nextofkin 	character varying(50),
    income 		numeric(12,2),
    created_by 	integer,
    createdon 	timestamp without time zone,
    modified_by integer,
    modifiedon 	timestamp without time zone
	);

	INSERT INTO tmp_clients(pid,type_id,firstname,middlename,othername,email,dob,phone,address,idnumber,nextofkin,income,created_by,createdon,modified_by,modifiedon)
	SELECT p.pid,p.type_id,p.firstname,p.middlename,p.othername,p.email,p.dob,p.phone,p.address,p.idnumber,p.nextofkin,p.income,p.created_by,p.createdon,p.modified_by,p.modifiedon
	FROM person p
	WHERE p.type_id=100
	ORDER BY pid;

	RETURN QUERY SELECT * 
	FROM tmp_clients ;

END; 

$$;
 0   DROP FUNCTION public.get_clients(_uid integer);
       public          postgres    false    4                        1255    16742    get_fields(character varying)    FUNCTION     �  CREATE FUNCTION public.get_fields(_table_name character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$

Declare 
    _fields	character varying;
	_field varchar(100);

BEGIN

    DECLARE cur_field CURSOR FOR 	SELECT column_name  FROM information_schema.columns
									WHERE table_schema = 'public' AND table_name   = _table_name
									order by ordinal_position;
    BEGIN
        OPEN cur_field;    
        LOOP
            FETCH cur_field INTO _field;
            EXIT WHEN NOT FOUND;
			
			_fields=CONCAT( coalesce(_fields,''),',',_field);
             
        END LOOP;

        CLOSE cur_field;
    END; 
	
	_fields=Right(_fields,length(_fields)-1);
	
	RETURN _fields;
END; 

$$;
 @   DROP FUNCTION public.get_fields(_table_name character varying);
       public          admin    false    4                       1255    18108    get_modules(integer)    FUNCTION     �  CREATE FUNCTION public.get_modules(_uid integer) RETURNS TABLE(mid integer, mname character varying, mtype character, madd boolean, medit boolean, mview boolean, mdelete boolean, murl character varying, mmain_menuid integer, mmenu_name character varying)
    LANGUAGE plpgsql
    AS $$
	
BEGIN

	DROP TABLE IF EXISTS tmp_modules;
	CREATE LOCAL TEMP TABLE  tmp_modules
	(
		id 			integer, 
		name 		character varying, 
		type		character(1),
		can_add		boolean,
		can_edit	boolean,
		can_view	boolean,
		can_delete	boolean,
		url 		character varying,
		main_menuid	integer,
		menu_name	character varying
	);

	INSERT INTO tmp_modules(id,name,type,can_add,can_edit,can_view,can_delete,url,main_menuid,menu_name)
	SELECT module.id,module.name,type,can_add,can_edit,can_view,can_delete,url,main_menu.id,main_menu.name
	FROM module JOIN menu ON module.id=menu.module_id
		JOIN main_menu ON menu.main_menuid=main_menu.id AND main_menu.active=true
	WHERE module.active=true
	ORDER BY main_menu.pos,menu.menu_order;

	--SELECT COUNT(1) FROM temp_child INTO _count ;
	--RAISE NOTICE 'Campaign Records (%)',_count;

	RETURN QUERY SELECT * 
	FROM tmp_modules ;

END; 

$$;
 0   DROP FUNCTION public.get_modules(_uid integer);
       public          postgres    false    4                       1255    16744    get_pname(integer)    FUNCTION       CREATE FUNCTION public.get_pname(_pid integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
	DECLARE
			_strName character varying;
					
BEGIN
	SELECT TRIM(firstname ||' '|| COALESCE(othername,'')) 
	FROM person 
	WHERE pid = _pid INTO _strName;

	RETURN _strName;
END;
$$;
 .   DROP FUNCTION public.get_pname(_pid integer);
       public          admin    false    4                       1255    16745    login_user(character varying)    FUNCTION     U  CREATE FUNCTION public.login_user(_username character varying) RETURNS TABLE(uid integer, upwd character varying, uname character varying)
    LANGUAGE plpgsql
    AS $$
	
BEGIN

	DROP TABLE IF EXISTS tmp_user;
	CREATE LOCAL TEMP TABLE  tmp_user
	(
		id 			integer, 
		pwd 		character varying, 
		name		character varying
	);

	INSERT INTO  tmp_user(id,pwd,name)
	SELECT id,password,get_pname(pid) FROM users WHERE username=_username;

	--SELECT COUNT(1) FROM temp_child INTO _count ;
	--RAISE NOTICE 'Campaign Records (%)',_count;

	RETURN QUERY SELECT id, pwd, name 
	FROM tmp_user ;

END; 

$$;
 >   DROP FUNCTION public.login_user(_username character varying);
       public          admin    false    4                       1255    28319 �   sp_upsert_person(integer, smallint, character varying, character varying, character varying, character varying, date, character varying, character varying, character varying, character varying, numeric, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.sp_upsert_person(_pid integer DEFAULT NULL::integer, _type_id smallint DEFAULT NULL::smallint, _firstname character varying DEFAULT NULL::character varying, _middlename character varying DEFAULT NULL::character varying, _othername character varying DEFAULT NULL::character varying, _email character varying DEFAULT NULL::character varying, _dob date DEFAULT NULL::date, _phone character varying DEFAULT NULL::character varying, _address character varying DEFAULT NULL::character varying, _idnumber character varying DEFAULT NULL::character varying, _nextofkin character varying DEFAULT NULL::character varying, _income numeric DEFAULT NULL::numeric, _user_id integer DEFAULT NULL::integer, _mode character varying DEFAULT '1'::character varying) RETURNS TABLE(new_id integer, message text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  DECLARE
    _new_pid INTEGER;
    _msg VARCHAR(500);
  BEGIN
    IF _mode = '1' THEN
      INSERT INTO person (
        type_id,
        firstname,
        middlename,
        othername,
        email,
        dob,
        phone,
        address,
        idnumber,
        nextofkin,
        income,
        created_by
      )
      VALUES (
        _type_id,
        _firstname,
        _middlename,
        _othername,
        _email,
        _dob,
        _phone,
        _address,
        _idnumber,
        _nextofkin,
        _income,
        _user_id
      )
      RETURNING pid INTO _new_pid;
    ELSE
      UPDATE person
      SET
        type_id = _type_id,
        firstname = _firstname,
        middlename = _middlename,
        othername = _othername,
        email = _email,
        dob = _dob,
        phone = _phone,
        address = _address,
        idnumber = _idnumber,
        nextofkin = _nextofkin,
        income = _income,
        modified_by = _user_id,
        modifiedon = now()
      WHERE pid = _pid;
      _new_pid := _pid;
    END IF;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Record with pid % not found for update', _pid;
    END IF;

    IF _mode = '1' THEN
      _msg := 'Data inserted successfully';
    ELSEIF _mode = '2' THEN
      _msg := 'Data updated successfully';
    END IF;

    RETURN QUERY SELECT _new_pid, _msg;
  END;
END;
$$;
 u  DROP FUNCTION public.sp_upsert_person(_pid integer, _type_id smallint, _firstname character varying, _middlename character varying, _othername character varying, _email character varying, _dob date, _phone character varying, _address character varying, _idnumber character varying, _nextofkin character varying, _income numeric, _user_id integer, _mode character varying);
       public          postgres    false    4                       1255    28321 �   sp_upsert_person2(integer, smallint, character varying, character varying, character varying, character varying, date, character varying, character varying, character varying, character varying, numeric, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.sp_upsert_person2(_pid integer DEFAULT NULL::integer, _type_id smallint DEFAULT NULL::smallint, _firstname character varying DEFAULT NULL::character varying, _middlename character varying DEFAULT NULL::character varying, _othername character varying DEFAULT NULL::character varying, _email character varying DEFAULT NULL::character varying, _dob date DEFAULT NULL::date, _phone character varying DEFAULT NULL::character varying, _address character varying DEFAULT NULL::character varying, _idnumber character varying DEFAULT NULL::character varying, _nextofkin character varying DEFAULT NULL::character varying, _income numeric DEFAULT NULL::numeric, _user_id integer DEFAULT NULL::integer, _mode character varying DEFAULT '1'::character varying) RETURNS TABLE(new_id integer, message text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  DECLARE
    _new_pid INTEGER;
    _msg VARCHAR(500);
  BEGIN
/*    IF _mode = '1' THEN
      INSERT INTO person (
        type_id,
        firstname,
        middlename,
        othername,
        email,
        dob,
        phone,
        address,
        idnumber,
        nextofkin,
        income,
        created_by
      )
      VALUES (
        _type_id,
        _firstname,
        _middlename,
        _othername,
        _email,
        _dob,
        _phone,
        _address,
        _idnumber,
        _nextofkin,
        _income,
        _user_id
      )
      RETURNING pid INTO _new_pid;
    ELSE
      UPDATE person
      SET
        type_id = _type_id,
        firstname = _firstname,
        middlename = _middlename,
        othername = _othername,
        email = _email,
        dob = _dob,
        phone = _phone,
        address = _address,
        idnumber = _idnumber,
        nextofkin = _nextofkin,
        income = _income,
        modified_by = _user_id,
        modifiedon = now()
      WHERE pid = _pid;
      _new_pid := _pid;
    END IF;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Record with pid % not found for update', _pid;
    END IF;
*/
    IF _mode = '1' THEN
      _msg := 'Data inserted successfully';
    ELSEIF _mode = '2' THEN
      _msg := 'Data updated successfully';
    END IF;

    RETURN QUERY SELECT _new_pid, _msg;
  END;
END;
$$;
 v  DROP FUNCTION public.sp_upsert_person2(_pid integer, _type_id smallint, _firstname character varying, _middlename character varying, _othername character varying, _email character varying, _dob date, _phone character varying, _address character varying, _idnumber character varying, _nextofkin character varying, _income numeric, _user_id integer, _mode character varying);
       public          postgres    false    4            �            1259    16746    account    TABLE     {  CREATE TABLE public.account (
    id character varying(25) NOT NULL,
    name character varying(50),
    product_id character varying(6) NOT NULL,
    balance numeric(12,4),
    active boolean,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone,
    pid integer NOT NULL
);
    DROP TABLE public.account;
       public         heap    postgres    false    4            �            1259    16750    dropdown    TABLE       CREATE TABLE public.dropdown (
    id integer NOT NULL,
    name character varying(50),
    groupid integer,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.dropdown;
       public         heap    postgres    false    4            �            1259    16754    dropdown_group    TABLE     �   CREATE TABLE public.dropdown_group (
    id integer NOT NULL,
    name character varying(50),
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
 "   DROP TABLE public.dropdown_group;
       public         heap    postgres    false    4            �            1259    16758    dropdown_group_id_seq    SEQUENCE     �   ALTER TABLE public.dropdown_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.dropdown_group_id_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    4    229            �            1259    16759    dropdown_id_seq    SEQUENCE     �   ALTER TABLE public.dropdown ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.dropdown_id_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    4    228            �            1259    16760    loan    TABLE     U  CREATE TABLE public.loan (
    id integer NOT NULL,
    pid integer NOT NULL,
    product_id character varying(6) NOT NULL,
    loanamount numeric(12,2) NOT NULL,
    term smallint NOT NULL,
    term_type_id smallint,
    calc_method_id integer,
    rate numeric(3,2),
    status_id integer NOT NULL,
    inst_start_date date,
    last_inst_date date,
    dis_date date,
    dis_mode_id integer,
    active boolean DEFAULT true NOT NULL,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.loan;
       public         heap    postgres    false    4            �            1259    16765    loan_id_seq    SEQUENCE     �   ALTER TABLE public.loan ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.loan_id_seq
    START WITH 100000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    4    232            �            1259    16766    loan_log    TABLE       CREATE TABLE public.loan_log (
    id integer NOT NULL,
    loan_id integer NOT NULL,
    status_id integer NOT NULL,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.loan_log;
       public         heap    postgres    false    4            �            1259    16770    loan_log_id_seq    SEQUENCE     �   ALTER TABLE public.loan_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.loan_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    234    4            �            1259    17996 	   main_menu    TABLE     4  CREATE TABLE public.main_menu (
    id integer NOT NULL,
    name character varying(50),
    pos smallint,
    active boolean DEFAULT true NOT NULL,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.main_menu;
       public         heap    postgres    false    4            �            1259    17995    main_menu_id_seq    SEQUENCE     �   ALTER TABLE public.main_menu ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.main_menu_id_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    250    4            �            1259    18016    menu    TABLE     F  CREATE TABLE public.menu (
    id integer NOT NULL,
    main_menuid integer,
    module_id integer,
    menu_order smallint,
    active boolean DEFAULT true NOT NULL,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.menu;
       public         heap    postgres    false    4            �            1259    18015    menu_id_seq    SEQUENCE     �   ALTER TABLE public.menu ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.menu_id_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    252    4            �            1259    16771    module    TABLE     �  CREATE TABLE public.module (
    id integer NOT NULL,
    name character varying(50),
    type character(1) NOT NULL,
    can_add boolean,
    can_edit boolean,
    can_view boolean,
    can_delete boolean,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone,
    active boolean DEFAULT false NOT NULL,
    url character varying(200)
);
    DROP TABLE public.module;
       public         heap    postgres    false    4            �            1259    16776    person    TABLE     �  CREATE TABLE public.person (
    pid integer NOT NULL,
    type_id smallint,
    firstname character varying(50),
    middlename character varying(50),
    othername character varying(50),
    email character varying(50),
    dob date,
    phone character varying(25),
    address character varying(100),
    idnumber character varying(20),
    nextofkin character varying(50),
    income numeric(12,2),
    created_by integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modified_by integer,
    modifiedon timestamp without time zone,
    CONSTRAINT chk_person_phone_format CHECK (((phone)::text ~ '[+][2][5][4][17][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'::text))
);
    DROP TABLE public.person;
       public         heap    postgres    false    4            �            1259    16781    person_pid_seq    SEQUENCE     �   ALTER TABLE public.person ALTER COLUMN pid ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.person_pid_seq
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    4    237            �            1259    16782    product    TABLE     �  CREATE TABLE public.product (
    id character varying(6) NOT NULL,
    name character varying(50),
    type_id integer NOT NULL,
    series character varying(10) NOT NULL,
    term_type_id integer NOT NULL,
    rate numeric(3,2),
    dterm smallint,
    damount numeric(12,2),
    calc_method_id integer,
    active boolean DEFAULT false NOT NULL,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.product;
       public         heap    postgres    false    4            �            1259    16787    role    TABLE       CREATE TABLE public.role (
    id integer NOT NULL,
    name character varying(50),
    active boolean DEFAULT true NOT NULL,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.role;
       public         heap    postgres    false    4            �            1259    16792 
   role_right    TABLE     \  CREATE TABLE public.role_right (
    id integer NOT NULL,
    roleid integer,
    moduleid integer,
    can_add boolean,
    can_edit boolean,
    can_view boolean,
    can_delete boolean,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.role_right;
       public         heap    postgres    false    4            �            1259    16796    role_right_id_seq    SEQUENCE     �   ALTER TABLE public.role_right ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.role_right_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    241    4            �            1259    16797    roles_id_seq    SEQUENCE     �   ALTER TABLE public.role ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.roles_id_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    240    4            �            1259    16798    sys_setting    TABLE     O  CREATE TABLE public.sys_setting (
    id character varying(25) NOT NULL,
    description character varying(100),
    value character varying(100) NOT NULL,
    active boolean,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.sys_setting;
       public         heap    postgres    false    4            �            1259    16802 	   user_role    TABLE        CREATE TABLE public.user_role (
    id integer NOT NULL,
    userid integer,
    roleid integer,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.user_role;
       public         heap    postgres    false    4            �            1259    16806    user_role_id_seq    SEQUENCE     �   ALTER TABLE public.user_role ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    245    4            �            1259    16807    users    TABLE     6  CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(50),
    pid integer,
    createdby integer,
    createdon timestamp without time zone DEFAULT now() NOT NULL,
    modifiedby integer,
    modifiedon timestamp without time zone
);
    DROP TABLE public.users;
       public         heap    postgres    false    4            �            1259    16811    users_id_seq    SEQUENCE     �   ALTER TABLE public.users ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    4    247            �          0    16746    account 
   TABLE DATA           {   COPY public.account (id, name, product_id, balance, active, createdby, createdon, modifiedby, modifiedon, pid) FROM stdin;
    public          postgres    false    227   �      �          0    16750    dropdown 
   TABLE DATA           c   COPY public.dropdown (id, name, groupid, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    228   �      �          0    16754    dropdown_group 
   TABLE DATA           `   COPY public.dropdown_group (id, name, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    229   �      �          0    16760    loan 
   TABLE DATA           �   COPY public.loan (id, pid, product_id, loanamount, term, term_type_id, calc_method_id, rate, status_id, inst_start_date, last_inst_date, dis_date, dis_mode_id, active, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    232   A      �          0    16766    loan_log 
   TABLE DATA           h   COPY public.loan_log (id, loan_id, status_id, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    234   ^      �          0    17996 	   main_menu 
   TABLE DATA           h   COPY public.main_menu (id, name, pos, active, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    250   {      �          0    18016    menu 
   TABLE DATA           |   COPY public.menu (id, main_menuid, module_id, menu_order, active, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    252   
      �          0    16771    module 
   TABLE DATA           �   COPY public.module (id, name, type, can_add, can_edit, can_view, can_delete, createdby, createdon, modifiedby, modifiedon, active, url) FROM stdin;
    public          postgres    false    236   �      �          0    16776    person 
   TABLE DATA           �   COPY public.person (pid, type_id, firstname, middlename, othername, email, dob, phone, address, idnumber, nextofkin, income, created_by, createdon, modified_by, modifiedon) FROM stdin;
    public          postgres    false    237   �      �          0    16782    product 
   TABLE DATA           �   COPY public.product (id, name, type_id, series, term_type_id, rate, dterm, damount, calc_method_id, active, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    239   �      �          0    16787    role 
   TABLE DATA           ^   COPY public.role (id, name, active, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    240         �          0    16792 
   role_right 
   TABLE DATA           �   COPY public.role_right (id, roleid, moduleid, can_add, can_edit, can_view, can_delete, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    241   5      �          0    16798    sys_setting 
   TABLE DATA           s   COPY public.sys_setting (id, description, value, active, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    244   R      �          0    16802 	   user_role 
   TABLE DATA           e   COPY public.user_role (id, userid, roleid, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    245   o      �          0    16807    users 
   TABLE DATA           j   COPY public.users (id, username, password, pid, createdby, createdon, modifiedby, modifiedon) FROM stdin;
    public          postgres    false    247   �      �           0    0    dropdown_group_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.dropdown_group_id_seq', 100, true);
          public          postgres    false    230            �           0    0    dropdown_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.dropdown_id_seq', 100, true);
          public          postgres    false    231                        0    0    loan_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.loan_id_seq', 100000, false);
          public          postgres    false    233                       0    0    loan_log_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.loan_log_id_seq', 1, false);
          public          postgres    false    235                       0    0    main_menu_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.main_menu_id_seq', 105, true);
          public          postgres    false    249                       0    0    menu_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.menu_id_seq', 110, true);
          public          postgres    false    251                       0    0    person_pid_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.person_pid_seq', 10013, true);
          public          postgres    false    238                       0    0    role_right_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.role_right_id_seq', 1, false);
          public          postgres    false    242                       0    0    roles_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.roles_id_seq', 100, false);
          public          postgres    false    243                       0    0    user_role_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.user_role_id_seq', 1, false);
          public          postgres    false    246                       0    0    users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_id_seq', 100, true);
          public          postgres    false    248            �           2606    16813    account pk_account 
   CONSTRAINT     P   ALTER TABLE ONLY public.account
    ADD CONSTRAINT pk_account PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.account DROP CONSTRAINT pk_account;
       public            postgres    false    227            �           2606    16815    dropdown pk_dropdown 
   CONSTRAINT     R   ALTER TABLE ONLY public.dropdown
    ADD CONSTRAINT pk_dropdown PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.dropdown DROP CONSTRAINT pk_dropdown;
       public            postgres    false    228            �           2606    16817     dropdown_group pk_dropdown_group 
   CONSTRAINT     ^   ALTER TABLE ONLY public.dropdown_group
    ADD CONSTRAINT pk_dropdown_group PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.dropdown_group DROP CONSTRAINT pk_dropdown_group;
       public            postgres    false    229            �           2606    16819    loan pk_loan 
   CONSTRAINT     J   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT pk_loan PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.loan DROP CONSTRAINT pk_loan;
       public            postgres    false    232            �           2606    16821    loan_log pk_loan_log 
   CONSTRAINT     R   ALTER TABLE ONLY public.loan_log
    ADD CONSTRAINT pk_loan_log PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.loan_log DROP CONSTRAINT pk_loan_log;
       public            postgres    false    234                       2606    18002    main_menu pk_main_menuid 
   CONSTRAINT     V   ALTER TABLE ONLY public.main_menu
    ADD CONSTRAINT pk_main_menuid PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.main_menu DROP CONSTRAINT pk_main_menuid;
       public            postgres    false    250            !           2606    18022    menu pk_menuid 
   CONSTRAINT     L   ALTER TABLE ONLY public.menu
    ADD CONSTRAINT pk_menuid PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.menu DROP CONSTRAINT pk_menuid;
       public            postgres    false    252            �           2606    16823    module pk_module 
   CONSTRAINT     N   ALTER TABLE ONLY public.module
    ADD CONSTRAINT pk_module PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.module DROP CONSTRAINT pk_module;
       public            postgres    false    236            �           2606    16825    person pk_person 
   CONSTRAINT     O   ALTER TABLE ONLY public.person
    ADD CONSTRAINT pk_person PRIMARY KEY (pid);
 :   ALTER TABLE ONLY public.person DROP CONSTRAINT pk_person;
       public            postgres    false    237                       2606    16827    product pk_product 
   CONSTRAINT     P   ALTER TABLE ONLY public.product
    ADD CONSTRAINT pk_product PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.product DROP CONSTRAINT pk_product;
       public            postgres    false    239                       2606    16829    role pk_role 
   CONSTRAINT     J   ALTER TABLE ONLY public.role
    ADD CONSTRAINT pk_role PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.role DROP CONSTRAINT pk_role;
       public            postgres    false    240                       2606    16831    role_right pk_role_right 
   CONSTRAINT     V   ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT pk_role_right PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.role_right DROP CONSTRAINT pk_role_right;
       public            postgres    false    241                       2606    16833    user_role pk_user_role 
   CONSTRAINT     T   ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT pk_user_role PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.user_role DROP CONSTRAINT pk_user_role;
       public            postgres    false    245                       2606    16835    users pk_users 
   CONSTRAINT     L   ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.users DROP CONSTRAINT pk_users;
       public            postgres    false    247                       2606    16837    sys_setting sys_setting_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.sys_setting
    ADD CONSTRAINT sys_setting_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.sys_setting DROP CONSTRAINT sys_setting_pkey;
       public            postgres    false    244                       2606    16839    users uc_users_username 
   CONSTRAINT     V   ALTER TABLE ONLY public.users
    ADD CONSTRAINT uc_users_username UNIQUE (username);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT uc_users_username;
       public            postgres    false    247            �           1259    16840    fki_fk_account_createdby    INDEX     Q   CREATE INDEX fki_fk_account_createdby ON public.account USING btree (createdby);
 ,   DROP INDEX public.fki_fk_account_createdby;
       public            postgres    false    227            �           1259    16841    fki_fk_account_modifiedby    INDEX     S   CREATE INDEX fki_fk_account_modifiedby ON public.account USING btree (modifiedby);
 -   DROP INDEX public.fki_fk_account_modifiedby;
       public            postgres    false    227            �           1259    16842    fki_fk_account_product_id    INDEX     S   CREATE INDEX fki_fk_account_product_id ON public.account USING btree (product_id);
 -   DROP INDEX public.fki_fk_account_product_id;
       public            postgres    false    227            �           1259    16843    fki_fk_drop_down_groupid    INDEX     P   CREATE INDEX fki_fk_drop_down_groupid ON public.dropdown USING btree (groupid);
 ,   DROP INDEX public.fki_fk_drop_down_groupid;
       public            postgres    false    228            �           1259    16844    fki_fk_dropdown_createdby    INDEX     S   CREATE INDEX fki_fk_dropdown_createdby ON public.dropdown USING btree (createdby);
 -   DROP INDEX public.fki_fk_dropdown_createdby;
       public            postgres    false    228            �           1259    16845    fki_fk_dropdown_group_createdby    INDEX     _   CREATE INDEX fki_fk_dropdown_group_createdby ON public.dropdown_group USING btree (createdby);
 3   DROP INDEX public.fki_fk_dropdown_group_createdby;
       public            postgres    false    229            �           1259    16846     fki_fk_dropdown_group_modifiedby    INDEX     a   CREATE INDEX fki_fk_dropdown_group_modifiedby ON public.dropdown_group USING btree (modifiedby);
 4   DROP INDEX public.fki_fk_dropdown_group_modifiedby;
       public            postgres    false    229            �           1259    16847    fki_fk_dropdown_modifiedby    INDEX     U   CREATE INDEX fki_fk_dropdown_modifiedby ON public.dropdown USING btree (modifiedby);
 .   DROP INDEX public.fki_fk_dropdown_modifiedby;
       public            postgres    false    228            �           1259    16848    fki_fk_loan_calc_method_id    INDEX     U   CREATE INDEX fki_fk_loan_calc_method_id ON public.loan USING btree (calc_method_id);
 .   DROP INDEX public.fki_fk_loan_calc_method_id;
       public            postgres    false    232            �           1259    16849    fki_fk_loan_createdby    INDEX     K   CREATE INDEX fki_fk_loan_createdby ON public.loan USING btree (createdby);
 )   DROP INDEX public.fki_fk_loan_createdby;
       public            postgres    false    232            �           1259    16850    fki_fk_loan_dis_mode_id    INDEX     O   CREATE INDEX fki_fk_loan_dis_mode_id ON public.loan USING btree (dis_mode_id);
 +   DROP INDEX public.fki_fk_loan_dis_mode_id;
       public            postgres    false    232            �           1259    16851    fki_fk_loan_log_createdby    INDEX     S   CREATE INDEX fki_fk_loan_log_createdby ON public.loan_log USING btree (createdby);
 -   DROP INDEX public.fki_fk_loan_log_createdby;
       public            postgres    false    234            �           1259    16852    fki_fk_loan_log_modifiedby    INDEX     U   CREATE INDEX fki_fk_loan_log_modifiedby ON public.loan_log USING btree (modifiedby);
 .   DROP INDEX public.fki_fk_loan_log_modifiedby;
       public            postgres    false    234            �           1259    16853    fki_fk_loan_log_status_id    INDEX     S   CREATE INDEX fki_fk_loan_log_status_id ON public.loan_log USING btree (status_id);
 -   DROP INDEX public.fki_fk_loan_log_status_id;
       public            postgres    false    234            �           1259    16854    fki_fk_loan_modifiedby    INDEX     M   CREATE INDEX fki_fk_loan_modifiedby ON public.loan USING btree (modifiedby);
 *   DROP INDEX public.fki_fk_loan_modifiedby;
       public            postgres    false    232            �           1259    16855    fki_fk_loan_pid    INDEX     ?   CREATE INDEX fki_fk_loan_pid ON public.loan USING btree (pid);
 #   DROP INDEX public.fki_fk_loan_pid;
       public            postgres    false    232            �           1259    16856    fki_fk_loan_product_id    INDEX     M   CREATE INDEX fki_fk_loan_product_id ON public.loan USING btree (product_id);
 *   DROP INDEX public.fki_fk_loan_product_id;
       public            postgres    false    232            �           1259    16857    fki_fk_loan_status_id    INDEX     K   CREATE INDEX fki_fk_loan_status_id ON public.loan USING btree (status_id);
 )   DROP INDEX public.fki_fk_loan_status_id;
       public            postgres    false    232            �           1259    16858    fki_fk_loan_term_type_id    INDEX     Q   CREATE INDEX fki_fk_loan_term_type_id ON public.loan USING btree (term_type_id);
 ,   DROP INDEX public.fki_fk_loan_term_type_id;
       public            postgres    false    232                       1259    18013    fki_fk_main_menu_createdby    INDEX     U   CREATE INDEX fki_fk_main_menu_createdby ON public.main_menu USING btree (createdby);
 .   DROP INDEX public.fki_fk_main_menu_createdby;
       public            postgres    false    250                       1259    18014    fki_fk_main_menu_modifiedby    INDEX     W   CREATE INDEX fki_fk_main_menu_modifiedby ON public.main_menu USING btree (modifiedby);
 /   DROP INDEX public.fki_fk_main_menu_modifiedby;
       public            postgres    false    250            �           1259    16859    fki_fk_person_createdby    INDEX     P   CREATE INDEX fki_fk_person_createdby ON public.person USING btree (created_by);
 +   DROP INDEX public.fki_fk_person_createdby;
       public            postgres    false    237            �           1259    16860    fki_fk_person_modifiedby    INDEX     R   CREATE INDEX fki_fk_person_modifiedby ON public.person USING btree (modified_by);
 ,   DROP INDEX public.fki_fk_person_modifiedby;
       public            postgres    false    237            �           1259    16861    fki_fk_person_type_id    INDEX     K   CREATE INDEX fki_fk_person_type_id ON public.person USING btree (type_id);
 )   DROP INDEX public.fki_fk_person_type_id;
       public            postgres    false    237            �           1259    16862    fki_fk_product_calc_method_id    INDEX     [   CREATE INDEX fki_fk_product_calc_method_id ON public.product USING btree (calc_method_id);
 1   DROP INDEX public.fki_fk_product_calc_method_id;
       public            postgres    false    239            �           1259    16863    fki_fk_product_createdby    INDEX     Q   CREATE INDEX fki_fk_product_createdby ON public.product USING btree (createdby);
 ,   DROP INDEX public.fki_fk_product_createdby;
       public            postgres    false    239            �           1259    16864    fki_fk_product_modifiedby    INDEX     S   CREATE INDEX fki_fk_product_modifiedby ON public.product USING btree (modifiedby);
 -   DROP INDEX public.fki_fk_product_modifiedby;
       public            postgres    false    239            �           1259    16865    fki_fk_product_term_type_id    INDEX     W   CREATE INDEX fki_fk_product_term_type_id ON public.product USING btree (term_type_id);
 /   DROP INDEX public.fki_fk_product_term_type_id;
       public            postgres    false    239                        1259    16866    fki_fk_product_type_id    INDEX     M   CREATE INDEX fki_fk_product_type_id ON public.product USING btree (type_id);
 *   DROP INDEX public.fki_fk_product_type_id;
       public            postgres    false    239                       1259    16867    fki_fk_role_createdby    INDEX     K   CREATE INDEX fki_fk_role_createdby ON public.role USING btree (createdby);
 )   DROP INDEX public.fki_fk_role_createdby;
       public            postgres    false    240                       1259    16868    fki_fk_role_modifiedby    INDEX     M   CREATE INDEX fki_fk_role_modifiedby ON public.role USING btree (modifiedby);
 *   DROP INDEX public.fki_fk_role_modifiedby;
       public            postgres    false    240                       1259    16869    fki_fk_role_right_createdby    INDEX     W   CREATE INDEX fki_fk_role_right_createdby ON public.role_right USING btree (createdby);
 /   DROP INDEX public.fki_fk_role_right_createdby;
       public            postgres    false    241                       1259    16870    fki_fk_role_right_modifiedby    INDEX     Y   CREATE INDEX fki_fk_role_right_modifiedby ON public.role_right USING btree (modifiedby);
 0   DROP INDEX public.fki_fk_role_right_modifiedby;
       public            postgres    false    241            	           1259    16871    fki_fk_role_right_moduleid    INDEX     U   CREATE INDEX fki_fk_role_right_moduleid ON public.role_right USING btree (moduleid);
 .   DROP INDEX public.fki_fk_role_right_moduleid;
       public            postgres    false    241            
           1259    16872    fki_fk_role_right_roleid    INDEX     Q   CREATE INDEX fki_fk_role_right_roleid ON public.role_right USING btree (roleid);
 ,   DROP INDEX public.fki_fk_role_right_roleid;
       public            postgres    false    241                       1259    16873    fki_fk_user_role_createdby    INDEX     U   CREATE INDEX fki_fk_user_role_createdby ON public.user_role USING btree (createdby);
 .   DROP INDEX public.fki_fk_user_role_createdby;
       public            postgres    false    245                       1259    16874    fki_fk_user_role_modifiedby    INDEX     W   CREATE INDEX fki_fk_user_role_modifiedby ON public.user_role USING btree (modifiedby);
 /   DROP INDEX public.fki_fk_user_role_modifiedby;
       public            postgres    false    245                       1259    16875    fki_fk_user_role_roleid    INDEX     O   CREATE INDEX fki_fk_user_role_roleid ON public.user_role USING btree (roleid);
 +   DROP INDEX public.fki_fk_user_role_roleid;
       public            postgres    false    245                       1259    16876    fki_fk_user_role_userid    INDEX     O   CREATE INDEX fki_fk_user_role_userid ON public.user_role USING btree (userid);
 +   DROP INDEX public.fki_fk_user_role_userid;
       public            postgres    false    245                       1259    16877    fki_fk_users_createdby    INDEX     M   CREATE INDEX fki_fk_users_createdby ON public.users USING btree (createdby);
 *   DROP INDEX public.fki_fk_users_createdby;
       public            postgres    false    247                       1259    16878    fki_fk_users_modifiedby    INDEX     O   CREATE INDEX fki_fk_users_modifiedby ON public.users USING btree (modifiedby);
 +   DROP INDEX public.fki_fk_users_modifiedby;
       public            postgres    false    247                       1259    16879    fki_fk_users_pid    INDEX     A   CREATE INDEX fki_fk_users_pid ON public.users USING btree (pid);
 $   DROP INDEX public.fki_fk_users_pid;
       public            postgres    false    247            �           1259    16880    ik_person_idnumber    INDEX     �   CREATE INDEX ik_person_idnumber ON public.person USING btree (idnumber);

ALTER TABLE public.person CLUSTER ON ik_person_idnumber;
 &   DROP INDEX public.ik_person_idnumber;
       public            postgres    false    237            "           2606    16881    account fk_account_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk_account_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 F   ALTER TABLE ONLY public.account DROP CONSTRAINT fk_account_createdby;
       public          postgres    false    247    227    3353            #           2606    16886    account fk_account_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk_account_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 G   ALTER TABLE ONLY public.account DROP CONSTRAINT fk_account_modifiedby;
       public          postgres    false    3353    247    227            $           2606    27192    account fk_account_pid    FK CONSTRAINT     }   ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk_account_pid FOREIGN KEY (pid) REFERENCES public.person(pid) NOT VALID;
 @   ALTER TABLE ONLY public.account DROP CONSTRAINT fk_account_pid;
       public          postgres    false    227    237    3323            %           2606    16891    account fk_account_product_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk_account_product_id FOREIGN KEY (product_id) REFERENCES public.product(id) NOT VALID;
 G   ALTER TABLE ONLY public.account DROP CONSTRAINT fk_account_product_id;
       public          postgres    false    239    3330    227            &           2606    16896    dropdown fk_drop_down_groupid    FK CONSTRAINT     �   ALTER TABLE ONLY public.dropdown
    ADD CONSTRAINT fk_drop_down_groupid FOREIGN KEY (groupid) REFERENCES public.dropdown_group(id) NOT VALID;
 G   ALTER TABLE ONLY public.dropdown DROP CONSTRAINT fk_drop_down_groupid;
       public          postgres    false    228    229    3300            '           2606    16901    dropdown fk_dropdown_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.dropdown
    ADD CONSTRAINT fk_dropdown_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 H   ALTER TABLE ONLY public.dropdown DROP CONSTRAINT fk_dropdown_createdby;
       public          postgres    false    228    3353    247            )           2606    16906 *   dropdown_group fk_dropdown_group_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.dropdown_group
    ADD CONSTRAINT fk_dropdown_group_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 T   ALTER TABLE ONLY public.dropdown_group DROP CONSTRAINT fk_dropdown_group_createdby;
       public          postgres    false    247    229    3353            *           2606    16911 +   dropdown_group fk_dropdown_group_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.dropdown_group
    ADD CONSTRAINT fk_dropdown_group_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 U   ALTER TABLE ONLY public.dropdown_group DROP CONSTRAINT fk_dropdown_group_modifiedby;
       public          postgres    false    3353    229    247            (           2606    16916    dropdown fk_dropdown_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.dropdown
    ADD CONSTRAINT fk_dropdown_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 I   ALTER TABLE ONLY public.dropdown DROP CONSTRAINT fk_dropdown_modifiedby;
       public          postgres    false    3353    228    247            +           2606    16921    loan fk_loan_calc_method_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT fk_loan_calc_method_id FOREIGN KEY (calc_method_id) REFERENCES public.dropdown(id) NOT VALID;
 E   ALTER TABLE ONLY public.loan DROP CONSTRAINT fk_loan_calc_method_id;
       public          postgres    false    3296    232    228            ,           2606    16926    loan fk_loan_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT fk_loan_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 @   ALTER TABLE ONLY public.loan DROP CONSTRAINT fk_loan_createdby;
       public          postgres    false    3353    232    247            -           2606    16931    loan fk_loan_dis_mode_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT fk_loan_dis_mode_id FOREIGN KEY (dis_mode_id) REFERENCES public.dropdown(id) NOT VALID;
 B   ALTER TABLE ONLY public.loan DROP CONSTRAINT fk_loan_dis_mode_id;
       public          postgres    false    3296    232    228            3           2606    16936    loan_log fk_loan_log_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan_log
    ADD CONSTRAINT fk_loan_log_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 H   ALTER TABLE ONLY public.loan_log DROP CONSTRAINT fk_loan_log_createdby;
       public          postgres    false    3353    247    234            4           2606    16941    loan_log fk_loan_log_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan_log
    ADD CONSTRAINT fk_loan_log_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 I   ALTER TABLE ONLY public.loan_log DROP CONSTRAINT fk_loan_log_modifiedby;
       public          postgres    false    247    3353    234            5           2606    16946    loan_log fk_loan_log_status_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan_log
    ADD CONSTRAINT fk_loan_log_status_id FOREIGN KEY (status_id) REFERENCES public.dropdown(id) NOT VALID;
 H   ALTER TABLE ONLY public.loan_log DROP CONSTRAINT fk_loan_log_status_id;
       public          postgres    false    228    234    3296            .           2606    16951    loan fk_loan_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT fk_loan_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 A   ALTER TABLE ONLY public.loan DROP CONSTRAINT fk_loan_modifiedby;
       public          postgres    false    247    232    3353            /           2606    16956    loan fk_loan_pid    FK CONSTRAINT     w   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT fk_loan_pid FOREIGN KEY (pid) REFERENCES public.person(pid) NOT VALID;
 :   ALTER TABLE ONLY public.loan DROP CONSTRAINT fk_loan_pid;
       public          postgres    false    237    3323    232            0           2606    16961    loan fk_loan_product_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT fk_loan_product_id FOREIGN KEY (product_id) REFERENCES public.product(id) NOT VALID;
 A   ALTER TABLE ONLY public.loan DROP CONSTRAINT fk_loan_product_id;
       public          postgres    false    3330    232    239            1           2606    16966    loan fk_loan_status_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT fk_loan_status_id FOREIGN KEY (status_id) REFERENCES public.dropdown(id) NOT VALID;
 @   ALTER TABLE ONLY public.loan DROP CONSTRAINT fk_loan_status_id;
       public          postgres    false    228    232    3296            2           2606    16971    loan fk_loan_term_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan
    ADD CONSTRAINT fk_loan_term_type_id FOREIGN KEY (term_type_id) REFERENCES public.dropdown(id) NOT VALID;
 C   ALTER TABLE ONLY public.loan DROP CONSTRAINT fk_loan_term_type_id;
       public          postgres    false    3296    232    228            L           2606    18003     main_menu fk_main_menu_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.main_menu
    ADD CONSTRAINT fk_main_menu_createdby FOREIGN KEY (createdby) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.main_menu DROP CONSTRAINT fk_main_menu_createdby;
       public          postgres    false    3353    250    247            M           2606    18008 !   main_menu fk_main_menu_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.main_menu
    ADD CONSTRAINT fk_main_menu_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id);
 K   ALTER TABLE ONLY public.main_menu DROP CONSTRAINT fk_main_menu_modifiedby;
       public          postgres    false    3353    250    247            N           2606    18033    menu fk_menu_createdby    FK CONSTRAINT     w   ALTER TABLE ONLY public.menu
    ADD CONSTRAINT fk_menu_createdby FOREIGN KEY (createdby) REFERENCES public.users(id);
 @   ALTER TABLE ONLY public.menu DROP CONSTRAINT fk_menu_createdby;
       public          postgres    false    247    252    3353            O           2606    18023    menu fk_menu_main_menuid    FK CONSTRAINT        ALTER TABLE ONLY public.menu
    ADD CONSTRAINT fk_menu_main_menuid FOREIGN KEY (main_menuid) REFERENCES public.main_menu(id);
 B   ALTER TABLE ONLY public.menu DROP CONSTRAINT fk_menu_main_menuid;
       public          postgres    false    3359    252    250            P           2606    18038    menu fk_menu_modifiedby    FK CONSTRAINT     y   ALTER TABLE ONLY public.menu
    ADD CONSTRAINT fk_menu_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id);
 A   ALTER TABLE ONLY public.menu DROP CONSTRAINT fk_menu_modifiedby;
       public          postgres    false    252    3353    247            Q           2606    18028    menu fk_menu_module_id    FK CONSTRAINT     x   ALTER TABLE ONLY public.menu
    ADD CONSTRAINT fk_menu_module_id FOREIGN KEY (module_id) REFERENCES public.module(id);
 @   ALTER TABLE ONLY public.menu DROP CONSTRAINT fk_menu_module_id;
       public          postgres    false    236    252    3317            7           2606    16976    person fk_person_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.person
    ADD CONSTRAINT fk_person_createdby FOREIGN KEY (created_by) REFERENCES public.users(id) NOT VALID;
 D   ALTER TABLE ONLY public.person DROP CONSTRAINT fk_person_createdby;
       public          postgres    false    247    237    3353            8           2606    16981    person fk_person_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.person
    ADD CONSTRAINT fk_person_modifiedby FOREIGN KEY (modified_by) REFERENCES public.users(id) NOT VALID;
 E   ALTER TABLE ONLY public.person DROP CONSTRAINT fk_person_modifiedby;
       public          postgres    false    3353    237    247            9           2606    16986    person fk_person_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.person
    ADD CONSTRAINT fk_person_type_id FOREIGN KEY (type_id) REFERENCES public.dropdown(id) NOT VALID;
 B   ALTER TABLE ONLY public.person DROP CONSTRAINT fk_person_type_id;
       public          postgres    false    228    237    3296            :           2606    16991 !   product fk_product_calc_method_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_calc_method_id FOREIGN KEY (calc_method_id) REFERENCES public.dropdown(id) NOT VALID;
 K   ALTER TABLE ONLY public.product DROP CONSTRAINT fk_product_calc_method_id;
       public          postgres    false    3296    239    228            ;           2606    16996    product fk_product_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 F   ALTER TABLE ONLY public.product DROP CONSTRAINT fk_product_createdby;
       public          postgres    false    247    239    3353            <           2606    17001    product fk_product_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 G   ALTER TABLE ONLY public.product DROP CONSTRAINT fk_product_modifiedby;
       public          postgres    false    247    239    3353            =           2606    17006    product fk_product_term_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_term_type_id FOREIGN KEY (term_type_id) REFERENCES public.dropdown(id) NOT VALID;
 I   ALTER TABLE ONLY public.product DROP CONSTRAINT fk_product_term_type_id;
       public          postgres    false    239    3296    228            >           2606    17011    product fk_product_type_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_type_id FOREIGN KEY (type_id) REFERENCES public.dropdown(id) NOT VALID;
 D   ALTER TABLE ONLY public.product DROP CONSTRAINT fk_product_type_id;
       public          postgres    false    228    239    3296            ?           2606    17016    role fk_role_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.role
    ADD CONSTRAINT fk_role_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 @   ALTER TABLE ONLY public.role DROP CONSTRAINT fk_role_createdby;
       public          postgres    false    247    240    3353            @           2606    17021    role fk_role_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.role
    ADD CONSTRAINT fk_role_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 A   ALTER TABLE ONLY public.role DROP CONSTRAINT fk_role_modifiedby;
       public          postgres    false    247    240    3353            A           2606    17026 "   role_right fk_role_right_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT fk_role_right_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 L   ALTER TABLE ONLY public.role_right DROP CONSTRAINT fk_role_right_createdby;
       public          postgres    false    3353    241    247            B           2606    17031 #   role_right fk_role_right_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT fk_role_right_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 M   ALTER TABLE ONLY public.role_right DROP CONSTRAINT fk_role_right_modifiedby;
       public          postgres    false    3353    247    241            C           2606    17036 !   role_right fk_role_right_moduleid    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT fk_role_right_moduleid FOREIGN KEY (moduleid) REFERENCES public.module(id) NOT VALID;
 K   ALTER TABLE ONLY public.role_right DROP CONSTRAINT fk_role_right_moduleid;
       public          postgres    false    241    3317    236            D           2606    17041    role_right fk_role_right_roleid    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_right
    ADD CONSTRAINT fk_role_right_roleid FOREIGN KEY (roleid) REFERENCES public.role(id) NOT VALID;
 I   ALTER TABLE ONLY public.role_right DROP CONSTRAINT fk_role_right_roleid;
       public          postgres    false    240    3334    241            E           2606    17046     user_role fk_user_role_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT fk_user_role_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 J   ALTER TABLE ONLY public.user_role DROP CONSTRAINT fk_user_role_createdby;
       public          postgres    false    247    245    3353            F           2606    17051 !   user_role fk_user_role_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT fk_user_role_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 K   ALTER TABLE ONLY public.user_role DROP CONSTRAINT fk_user_role_modifiedby;
       public          postgres    false    245    3353    247            G           2606    17056    user_role fk_user_role_roleid    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT fk_user_role_roleid FOREIGN KEY (roleid) REFERENCES public.role(id) NOT VALID;
 G   ALTER TABLE ONLY public.user_role DROP CONSTRAINT fk_user_role_roleid;
       public          postgres    false    3334    240    245            H           2606    17061    user_role fk_user_role_userid    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT fk_user_role_userid FOREIGN KEY (userid) REFERENCES public.users(id) NOT VALID;
 G   ALTER TABLE ONLY public.user_role DROP CONSTRAINT fk_user_role_userid;
       public          postgres    false    245    247    3353            I           2606    17066    users fk_users_createdby    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_createdby FOREIGN KEY (createdby) REFERENCES public.users(id) NOT VALID;
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_users_createdby;
       public          postgres    false    247    3353    247            J           2606    17071    users fk_users_modifiedby    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_modifiedby FOREIGN KEY (modifiedby) REFERENCES public.users(id) NOT VALID;
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_users_modifiedby;
       public          postgres    false    3353    247    247            K           2606    17076    users fk_users_pid    FK CONSTRAINT     y   ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_pid FOREIGN KEY (pid) REFERENCES public.person(pid) NOT VALID;
 <   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_users_pid;
       public          postgres    false    3323    247    237            6           2606    17081    loan_log loan_log_loanid    FK CONSTRAINT     �   ALTER TABLE ONLY public.loan_log
    ADD CONSTRAINT loan_log_loanid FOREIGN KEY (loan_id) REFERENCES public.loan(id) NOT VALID;
 B   ALTER TABLE ONLY public.loan_log DROP CONSTRAINT loan_log_loanid;
       public          postgres    false    3310    232    234            �      x������ � �      �   ;   x�340�t��L�+�42A����D��X��\��������H�����3���b���� _[m      �   ?   x�340�H-*��S�,H�4��Lt�u��M�̭L��M-9c���+F��� ���      �      x������ � �      �      x������ � �      �      x���1�0D�z|
.�hwm���	Q e�(q��FΦ���X��KO&�m�Y�~�PpB��A���$vra�˅1?��ף���+��,y��'��)Uw�~�p=������]۵e�T2νp�1?,F      �   �   x����!г�b y�	�"R�����8d/9�%,.<1� 3�z}wa�ʨ���t�n���g0(F<cd�8{��6`���(��T��l�m$��St��l����̤褚0������V�l�-��<������h�i�      �   !  x����n� ��3>/�����zk�c�,.۩��ZjY��-{����d�IЃ��� c�QtF7�쉝���c�W�A�Y�$�0� 9>�%�&轢���=/W�!�x��Z�@�s��2F�������,-=蚼�����r.�R���J]s�UC�m�䩲R7˗��Y�]�u;�Q�@tl�������Ɔ�����$����B�{�M>�O��8�J,�O�ӎ��Un�YC��֔�C�򇐖��ڀ��)�I����ed��۸��G�4�5^�P�<A���ٺ�t��IE߸� o      �     x�u��n� ���Ƚ2b��pJ���.R{�;V�z����/8K+%E�����`����)e/���	�9�a�/�鸭�id_�1V}Ś:�o7q�1'�@�9��"�B�FG�x�/�e(���ZV�.�99qx %��r����P�ɵ1<�}�x
u�H���i���,P:,�RLi4��� ��W���O��.��0��!�6$�CK!��U(g�{��!w���c/f���V~�r7 6G{RY)�AĈ0�A�}�&�gN3JS!���e�<�y�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   ;   x�340��4�44 �?N###]CC]#cCs+cK+C=ssCCc3�l�W� l
     