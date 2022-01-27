SELECT
	d.[primary key],
	d.[foreign key],
	CASE
		WHEN LEN(d.[column]) = 0 THEN d.[table]
		ELSE ''
	END	AS [table],
	d.[column],
	CAST(d.[description] AS VARCHAR(MAX)) AS [description],
	d.[data type],
	d.nullable,
	d.[identity],
	d.[default]
FROM
	(
		SELECT
			'' AS [primary key],
			'' AS [foreign key],
			s.[name] AS [schema],
			CASE
				WHEN s.[name] = 'dbo' THEN t.[name]
				ELSE s.[name] + '.' + t.[name]
			END AS [table],
			'' AS [column],
			ISNULL(RTRIM(CAST(ep.[value] AS NVARCHAR(4000))), '') AS [description],
			'' AS [data type],
			'' AS nullable,
			'' AS [identity],
			'' AS [default],
			NULL AS column_id
		FROM
			sys.tables t

				INNER JOIN sys.schemas s ON
					s.[schema_id] = t.[schema_id]

				-- get description of table, if available
				LEFT OUTER JOIN sys.extended_properties ep ON
					ep.major_id = t.[object_id] AND
					ep.minor_id = 0 AND
					ep.name = 'MS_Description' AND
					ep.class = 1
		WHERE
			t.is_ms_shipped = 0 AND
			NOT EXISTS
			(
				SELECT *
				FROM
					sys.extended_properties ms
				WHERE
					ms.major_id = t.[object_id] AND
					ms.minor_id = 0 AND
					ms.class = 1 AND
					ms.[name] = 'microsoft_database_tools_support'
			)

		UNION ALL

		SELECT
			CASE
				WHEN pk.column_id IS NOT NULL THEN 'PK'
				ELSE ''
			END AS [primary key],
			CASE
				WHEN fk.primary_table IS NOT NULL
					THEN fk.primary_table + '.' + fk.primary_column
				ELSE ''
			END AS [foreign key],
			s.[name] AS [schema],
			CASE
				WHEN s.[name] = 'dbo' THEN t.[name]
				ELSE s.[name] + '.' + t.[name]
			END AS [table],
			c.[name] AS [column],
			ISNULL(RTRIM(CAST(ep.[value] AS NVARCHAR(4000))), '') AS [description],
			CASE
				WHEN uty.[name] IS NOT NULL THEN uty.[name]
				ELSE ''
			END +
				CASE
					WHEN uty.[name] IS NOT NULL AND sty.[name] IS NOT NULL THEN '('
					ELSE ''
				END +
				CASE
					WHEN sty.[name] IS NOT NULL THEN sty.[name]
					ELSE ''
				END +
				CASE
					WHEN sty.[name] IN ('char', 'nchar', 'varchar', 'nvarchar', 'binary', 'varbinary')
						THEN '(' +
							CASE
								WHEN c.max_length = -1 THEN 'max'
								ELSE
									CASE
										WHEN sty.[name] IN ('nchar', 'nvarchar')
											THEN CAST(c.max_length / 2 AS VARCHAR(MAX))
										ELSE
											CAST(c.max_length AS VARCHAR(MAX))
									END
							END
							 + ')'
					WHEN sty.[name] IN ('numeric', 'decimal')
						THEN '(' +
							CAST(c.precision AS VARCHAR(MAX)) + ', ' + CAST(c.scale AS VARCHAR(MAX))
							 + ')'
					ELSE
						''
				END +
				CASE
					WHEN uty.[name] IS NOT NULL AND sty.[name] IS NOT NULL THEN ')'
					ELSE ''
				END	AS [data type],
			CASE
				WHEN c.is_nullable = 1 THEN 'Y'
				ELSE ''
			END AS nullable,
			CASE
				WHEN c.is_identity = 1 THEN 'Y'
				ELSE ''
			END AS [identity],
			ISNULL(dc.[definition], '') AS [default],
			c.column_id
		FROM
			sys.columns c
				INNER JOIN sys.tables t ON
					t.[object_id] = c.[object_id]

				INNER JOIN sys.schemas s ON
					s.[schema_id] = t.[schema_id]

				-- get name of user data type
				LEFT OUTER JOIN sys.types uty ON
					uty.system_type_id = c.system_type_id AND
					uty.user_type_id = c.user_type_id AND
					c.user_type_id <> c.system_type_id

				-- get name of system data type
				LEFT OUTER JOIN sys.types sty ON
					sty.system_type_id = c.system_type_id AND
					sty.user_type_id = c.system_type_id

				-- get description of column, if available
				LEFT OUTER JOIN sys.extended_properties ep ON
					ep.major_id = t.[object_id] AND
					ep.minor_id = c.column_id AND
					ep.[name] = 'MS_Description' AND
					ep.[class] = 1

				-- get default's code text
				LEFT OUTER JOIN sys.default_constraints dc ON
					dc.parent_object_id = t.[object_id] AND
					dc.parent_column_id = c.column_id

				-- check for inclusion in primary key
				LEFT OUTER JOIN
				(
					SELECT
						ic.column_id,
						i.[object_id]
					FROM
						sys.indexes i
							INNER JOIN sys.index_columns ic ON
								ic.index_id = i.index_id AND
								ic.[object_id] = i.[object_id]
					WHERE
						i.is_primary_key = 1
				) pk ON
					pk.column_id = c.column_id AND
					pk.[object_id] = t.[object_id]

				-- check for inclusion in foreign key
				LEFT OUTER JOIN
				(
					SELECT
						CASE
							WHEN s.[name] = 'dbo' THEN pk.[name]
							ELSE s.[name] + '.' + pk.[name]
						END AS primary_table,
						pkc.[name] as primary_column,
						fkc.parent_object_id,
						fkc.parent_column_id
					FROM
						sys.foreign_keys fk
							INNER JOIN sys.tables pk ON
								fk.referenced_object_id = pk.[object_id]
							INNER JOIN sys.schemas s ON
								s.[schema_id] = pk.[schema_id]
							INNER JOIN sys.foreign_key_columns fkc ON
								fkc.constraint_object_id = fk.[object_id] AND
								fkc.referenced_object_id = pk.[object_id]
							INNER JOIN sys.columns pkc ON
								pkc.[object_id] = pk.[object_id] AND
								pkc.column_id = fkc.referenced_column_id
				) fk ON
					fk.parent_object_id = t.[object_id] AND
					fk.parent_column_id = c.column_id
		WHERE
			t.is_ms_shipped = 0 AND
			NOT EXISTS
			(
				SELECT *
				FROM
					sys.extended_properties ms
				WHERE
					ms.major_id = t.[object_id] AND
					ms.minor_id = 0 AND
					ms.class = 1 AND
					ms.[name] = 'microsoft_database_tools_support'
			)
	) d
ORDER BY
	d.[schema],
	d.[table],
	d.column_id;
