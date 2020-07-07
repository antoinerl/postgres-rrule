
CREATE OR REPLACE FUNCTION _rrule.text(_rrule.RRULE)
RETURNS TEXT AS $$
  SELECT regexp_replace(
    'RRULE:'
    || COALESCE('FREQ=' || $1."freq" || ';', '')
    || CASE WHEN $1."interval" = 1 THEN '' ELSE COALESCE('INTERVAL=' || $1."interval" || ';', '') END
    || COALESCE('COUNT=' || $1."count" || ';', '')
    || COALESCE('UNTIL=' || $1."until" || ';', '')
    || COALESCE('BYSECOND=' || _rrule.array_join($1."bysecond", ',') || ';', '')
    || COALESCE('BYMINUTE=' || _rrule.array_join($1."byminute", ',') || ';', '')
    || COALESCE('BYHOUR=' || _rrule.array_join($1."byhour", ',') || ';', '')
    || COALESCE('BYDAY=' || _rrule.array_join($1."byday", ',') || ';', '')
    || COALESCE('BYMONTHDAY=' || _rrule.array_join($1."bymonthday", ',') || ';', '')
    || COALESCE('BYYEARDAY=' || _rrule.array_join($1."byyearday", ',') || ';', '')
    || COALESCE('BYWEEKNO=' || _rrule.array_join($1."byweekno", ',') || ';', '')
    || COALESCE('BYMONTH=' || _rrule.array_join($1."bymonth", ',') || ';', '')
    || COALESCE('BYSETPOS=' || _rrule.array_join($1."bysetpos", ',') || ';', '')
    || CASE WHEN $1."wkst" = 'MO' THEN '' ELSE COALESCE('WKST=' || $1."wkst" || ';', '') END
  , ';$', '');
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION _rrule.text("input" _rrule.RRULESET)
RETURNS TEXT AS $$
DECLARE
  rrule TEXT;
  exrule TEXT;
BEGIN
  SELECT _rrule.text("input"."rrule")
  INTO rrule;

  SELECT _rrule.text("input"."exrule")
  INTO exrule;

  RETURN
    COALESCE('DTSTART:' || "input"."dtstart" || '\n', '')
    || COALESCE('DTEND:' || "input"."dtend" || '\n', '')
    || COALESCE(rrule || '\n', '')
    || COALESCE(exrule || '\n', '')
    || COALESCE('RDATE:' || _rrule.array_join("input"."rdate", ',') || '\n', '')
    || COALESCE('EXDATE:' || _rrule.array_join("input"."exdate", ',') || '\n', '');
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;
