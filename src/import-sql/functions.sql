CREATE OR REPLACE FUNCTION localrank_poi(type VARCHAR) RETURNS INTEGER
AS $$
BEGIN
    RETURN CASE
        WHEN type IN ('station', 'subway_entrance', 'park', 'cemetery', 'bank', 'supermarket', 'car', 'library', 'university', 'college', 'police', 'townhall', 'courthouse') THEN 2
        WHEN type IN ('nature_reserve', 'garden', 'public_building') THEN 3
        WHEN type IN ('stadium') THEN 90
        WHEN type IN ('hospital') THEN 100
        WHEN type IN ('zoo') THEN 200
        WHEN type IN ('university', 'school', 'college', 'kindergarten') THEN 300
        WHEN type IN ('supermarket', 'department_store') THEN 400
        WHEN type IN ('nature_reserve', 'swimming_area') THEN 500
        WHEN type IN ('attraction') THEN 600
        ELSE 1000
    END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION localrank_road(type VARCHAR) RETURNS INTEGER
AS $$
BEGIN
    RETURN CASE
        WHEN type IN ('motorway') THEN 10
        WHEN type IN ('trunk') THEN 20
        WHEN type IN ('primary') THEN 30
        WHEN type IN ('secondary') THEN 40
        WHEN type IN ('tertiary') THEN 50
        ELSE 100
    END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION normalize_scalerank(scalerank INTEGER) RETURNS INTEGER
AS $$
BEGIN
    RETURN CASE
        WHEN scalerank >= 9 THEN 9
        ELSE scalerank
    END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION scalerank_poi(type VARCHAR, area REAL) RETURNS INTEGER
AS $$
BEGIN
    RETURN CASE
        WHEN area > 145000 THEN 1
        WHEN area > 12780 THEN 2
        WHEN area > 2960 THEN 3
        WHEN type IN ('station') THEN 1
        ELSE 4
    END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION classify_road_railway(type VARCHAR, service VARCHAR) RETURNS VARCHAR
AS $$
BEGIN
    RETURN CASE
        WHEN type = 'rail' AND service IN ('yard', 'siding', 'spur', 'crossover') THEN 'minor_rail'
        ELSE classify_road(type)
    END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION poi_address(housenumber VARCHAR, street VARCHAR, place VARCHAR, city VARCHAR, country VARCHAR, postcode VARCHAR) RETURNS VARCHAR
AS $$
BEGIN
    RETURN concat_ws(' ', housenumber, street, place, city, country, postcode);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION poi_network(type VARCHAR) RETURNS VARCHAR
AS $$
BEGIN
    RETURN CASE
        WHEN type IN ('station') THEN 'rail'
        ELSE ''
    END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION format_type(class VARCHAR) RETURNS VARCHAR
AS $$
BEGIN
    RETURN REPLACE(INITCAP(class), '_', ' ');
END;
$$ LANGUAGE plpgsql IMMUTABLE;
