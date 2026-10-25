from __future__ import annotations

import datetime as _pydt
import time as _pytime
try:
    import zoneinfo as _zoneinfo
except ImportError:
    _zoneinfo = None

_EPOCH_DT = _pydt.datetime(1970, 1, 1, 0, 0, 0, tzinfo=_pydt.timezone.utc)


def _civil_from_days(days: int) -> tuple[int, int, int]:
    """Howard Hinnant civil calendar algorithm (days -> year, month, day)."""
    z = days + 719468
    era = (z if z >= 0 else z - 146096) // 146097
    doe = z - era * 146097
    yoe = (doe - doe // 1460 + doe // 36524 - doe // 146096) // 365
    y = yoe + era * 400
    doy = doe - (365 * yoe + yoe // 4 - yoe // 100)
    mp = (5 * doy + 2) // 153
    d = doy - (153 * mp + 2) // 5 + 1
    m = mp + 3 if mp < 10 else mp - 9
    year = y + 1 if m <= 2 else y
    return year, m, d


def _days_from_civil(year: int, month: int, day: int) -> int:
    """Howard Hinnant civil calendar reverse algorithm (year, month, day -> days)."""
    y = year - 1 if month <= 2 else year
    era = (y if y >= 0 else y - 399) // 400
    yoe = y - era * 400
    m_prime = month + 9 if month <= 2 else month - 3
    doy = (153 * m_prime + 2) // 5 + day - 1
    doe = yoe * 365 + yoe // 4 - yoe // 100 + doy
    return era * 146097 + doe - 719468


def dt_is_leap_year_val(year: int) -> bool:
    return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)


def dt_days_in_month_val(year: int, month: int) -> int:
    if month in (1, 3, 5, 7, 8, 10, 12):
        return 31
    if month in (4, 6, 9, 11):
        return 30
    if month == 2:
        return 29 if dt_is_leap_year_val(year) else 28
    return 30


def _split_nanos(nanos: int) -> tuple[int, int, int, int, int, int, int, int, int]:
    """Returns (year, month, day, hour, min, sec, ms, us, ns)."""
    sec = nanos // 1_000_000_000
    frac = nanos % 1_000_000_000
    if frac < 0:
        frac += 1_000_000_000
        sec -= 1
    days = sec // 86400
    rem_sec = sec % 86400
    if rem_sec < 0:
        rem_sec += 86400
        days -= 1
    hour = rem_sec // 3600
    min_rem = rem_sec % 3600
    minute = min_rem // 60
    second = min_rem % 60
    ms = frac // 1_000_000
    us = (frac // 1000) % 1_000_000
    ns = frac % 1000
    year, month, day = _civil_from_days(days)
    return year, month, day, hour, minute, second, ms, us, frac


def dt_now() -> int:
    t = _pytime.time_ns()
    return t


def dt_today() -> int:
    y, m, d, _, _, _, _, _, _ = _split_nanos(dt_now())
    return _days_from_civil(y, m, d) * 86400 * 1_000_000_000


def dt_time() -> int:
    nanos = dt_now()
    sec = nanos // 1_000_000_000
    frac = nanos % 1_000_000_000
    rem_sec = sec % 86400
    return rem_sec * 1_000_000_000 + frac


def dt_to_iso(nanos: int) -> str:
    y, mo, d, h, mi, s, _, _, frac = _split_nanos(nanos)
    return f"{y:04d}-{mo:02d}-{d:02d}T{h:02d}:{mi:02d}:{s:02d}.{frac:09d}Z"


def dt_now_formatted() -> str:
    return dt_to_iso(dt_now())


def dt_format_duration(duration_ns: int) -> str:
    if duration_ns == 0:
        return "0s"
    prefix = "-" if duration_ns < 0 else ""
    ns = abs(duration_ns)
    s = ns // 1_000_000_000
    rem_ns = ns % 1_000_000_000
    if s == 0:
        if rem_ns % 1_000_000 == 0:
            return f"{prefix}{rem_ns // 1_000_000}ms"
        if rem_ns % 1000 == 0:
            return f"{prefix}{rem_ns // 1000}us"
        return f"{prefix}{rem_ns}ns"
    if s < 60:
        ms = rem_ns // 1_000_000
        if ms > 0:
            return f"{prefix}{s}.{ms:03d}s"
        return f"{prefix}{s}s"
    m = s // 60
    s = s % 60
    if m < 60:
        return f"{prefix}{m}m {s}s"
    h = m // 60
    m = m % 60
    if h < 24:
        return f"{prefix}{h}h {m}m {s}s"
    d = h // 24
    h = h % 24
    return f"{prefix}{d}d {h}h {m}m {s}s"


def dt_create_date(y: int, m: int, d: int) -> int:
    days = _days_from_civil(y, m, d)
    return days * 86400 * 1_000_000_000


def dt_create_time(h: int, m: int, s: int) -> int:
    return (h * 3600 + m * 60 + s) * 1_000_000_000


def dt_create_time_full(h: int, m: int, s: int, ms: int, us: int, ns: int) -> int:
    return (h * 3600 + m * 60 + s) * 1_000_000_000 + ms * 1_000_000 + us * 1000 + ns


def dt_parse_iso(text: str) -> int:
    from flux_proto.interpreter.interpreter import _parse_iso_nanos
    return _parse_iso_nanos(text.strip())


def dt_format(nanos: int, pattern: str) -> str:
    sec = nanos // 1_000_000_000
    base = _pydt.datetime.fromtimestamp(sec, tz=_pydt.timezone.utc)
    return base.strftime(pattern)


def dt_year(nanos: int) -> int:
    y, _, _, _, _, _, _, _, _ = _split_nanos(nanos)
    return y


def dt_month(nanos: int) -> int:
    _, m, _, _, _, _, _, _, _ = _split_nanos(nanos)
    return m


def dt_day(nanos: int) -> int:
    _, _, d, _, _, _, _, _, _ = _split_nanos(nanos)
    return d


def dt_weekday(nanos: int) -> int:
    sec = nanos // 1_000_000_000
    days = sec // 86400
    if nanos % 1_000_000_000 < 0 or sec % 86400 < 0:
        pass
    return ((days + 3) % 7 + 7) % 7 + 1


def dt_day_of_year(nanos: int) -> int:
    y, m, d, _, _, _, _, _, _ = _split_nanos(nanos)
    prior_days = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
    leap = 1 if (m > 2 and dt_is_leap_year_val(y)) else 0
    return prior_days[m - 1] + d + leap


def dt_days_in_month(nanos: int) -> int:
    y, m, _, _, _, _, _, _, _ = _split_nanos(nanos)
    return dt_days_in_month_val(y, m)


def dt_quarter(nanos: int) -> int:
    _, m, _, _, _, _, _, _, _ = _split_nanos(nanos)
    return (m - 1) // 3 + 1


def dt_is_leap_year(nanos: int) -> bool:
    y, _, _, _, _, _, _, _, _ = _split_nanos(nanos)
    return dt_is_leap_year_val(y)


def dt_is_weekend(nanos: int) -> bool:
    w = dt_weekday(nanos)
    return w in (6, 7)


def dt_add_days(nanos: int, amount: int) -> int:
    return nanos + amount * 86400 * 1_000_000_000


def dt_add_hours(nanos: int, amount: int) -> int:
    return nanos + amount * 3600 * 1_000_000_000


def dt_add_minutes(nanos: int, amount: int) -> int:
    return nanos + amount * 60 * 1_000_000_000


def dt_add_seconds(nanos: int, amount: int) -> int:
    return nanos + amount * 1_000_000_000


def dt_add_milliseconds(nanos: int, amount: int) -> int:
    return nanos + amount * 1_000_000


def dt_add_microseconds(nanos: int, amount: int) -> int:
    return nanos + amount * 1000


def dt_add_nanoseconds(nanos: int, amount: int) -> int:
    return nanos + amount


def dt_add_months(nanos: int, amount: int) -> int:
    y, m, d, h, mi, s, _, _, frac = _split_nanos(nanos)
    total_m = (y * 12 + (m - 1)) + amount
    new_y = total_m // 12
    new_m = total_m % 12 + 1
    max_d = dt_days_in_month_val(new_y, new_m)
    new_d = min(d, max_d)
    return dt_create_date(new_y, new_m, new_d) + (h * 3600 + mi * 60 + s) * 1_000_000_000 + frac


def dt_add_years(nanos: int, amount: int) -> int:
    return dt_add_months(nanos, amount * 12)


def dt_days_between(left: int, right: int) -> int:
    return (right - left) // (86400 * 1_000_000_000)


def dt_hours_between(left: int, right: int) -> int:
    return (right - left) // (3600 * 1_000_000_000)


def dt_minutes_between(left: int, right: int) -> int:
    return (right - left) // (60 * 1_000_000_000)


def dt_seconds_between(left: int, right: int) -> int:
    return (right - left) // 1_000_000_000


def dt_milliseconds_between(left: int, right: int) -> int:
    return (right - left) // 1_000_000


def dt_microseconds_between(left: int, right: int) -> int:
    return (right - left) // 1000


def dt_nanoseconds_between(left: int, right: int) -> int:
    return right - left


def dt_months_between(left: int, right: int) -> int:
    y1, m1, d1, _, _, _, _, _, _ = _split_nanos(left)
    y2, m2, d2, _, _, _, _, _, _ = _split_nanos(right)
    dm = (y2 - y1) * 12 + (m2 - m1)
    if dm > 0 and d2 < d1:
        dm -= 1
    elif dm < 0 and d2 > d1:
        dm += 1
    return dm


def dt_years_between(left: int, right: int) -> int:
    y1, m1, d1, _, _, _, _, _, _ = _split_nanos(left)
    y2, m2, d2, _, _, _, _, _, _ = _split_nanos(right)
    dy = y2 - y1
    if dy > 0 and (m2 < m1 or (m2 == m1 and d2 < d1)):
        dy -= 1
    elif dy < 0 and (m2 > m1 or (m2 == m1 and d2 > d1)):
        dy += 1
    return dy


def dt_hour(nanos: int) -> int:
    _, _, _, h, _, _, _, _, _ = _split_nanos(nanos)
    return h


def dt_minute(nanos: int) -> int:
    _, _, _, _, mi, _, _, _, _ = _split_nanos(nanos)
    return mi


def dt_second(nanos: int) -> int:
    _, _, _, _, _, s, _, _, _ = _split_nanos(nanos)
    return s


def dt_millisecond(nanos: int) -> int:
    _, _, _, _, _, _, ms, _, _ = _split_nanos(nanos)
    return ms


def dt_microsecond(nanos: int) -> int:
    _, _, _, _, _, _, _, us, _ = _split_nanos(nanos)
    return us


def dt_nanosecond(nanos: int) -> int:
    _, _, _, _, _, _, _, _, frac = _split_nanos(nanos)
    return frac


def dt_is_before(left: int, right: int) -> bool:
    return left < right


def dt_is_after(left: int, right: int) -> bool:
    return left > right


def dt_compare(left: int, right: int) -> int:
    if left < right:
        return -1
    if left > right:
        return 1
    return 0


def _get_tz(tz_name: str) -> _pydt.tzinfo:
    if not tz_name or tz_name in ("UTC", "Z"):
        return _pydt.timezone.utc
    if _zoneinfo is not None:
        try:
            return _zoneinfo.ZoneInfo(tz_name)
        except Exception:
            pass
    if tz_name in ("America/Sao_Paulo", "BRT"):
        return _pydt.timezone(_pydt.timedelta(hours=-3))
    return _pydt.timezone.utc


def dt_to_timezone(nanos: int, tz_name: str) -> str:
    sec = nanos // 1_000_000_000
    frac = nanos % 1_000_000_000
    tz = _get_tz(tz_name)
    base = _pydt.datetime.fromtimestamp(sec, tz=_pydt.timezone.utc).astimezone(tz)
    off = base.utcoffset()
    off_str = "Z"
    if off is not None:
        total_m = int(off.total_seconds() // 60)
        sign = "+" if total_m >= 0 else "-"
        total_m = abs(total_m)
        oh, om = divmod(total_m, 60)
        off_str = f"{sign}{oh:02d}:{om:02d}"
    return f"{base.year:04d}-{base.month:02d}-{base.day:02d}T{base.hour:02d}:{base.minute:02d}:{base.second:02d}.{frac:09d}{off_str}"


def dt_to_local(nanos: int) -> str:
    local_tz = dt_local_timezone()
    return dt_to_timezone(nanos, local_tz)


def dt_to_utc(nanos: int) -> int:
    return nanos


def dt_utc_offset(nanos: int, tz_name: str) -> float:
    sec = nanos // 1_000_000_000
    tz = _get_tz(tz_name)
    base = _pydt.datetime.fromtimestamp(sec, tz=_pydt.timezone.utc).astimezone(tz)
    off = base.utcoffset()
    if off is None:
        return 0.0
    return off.total_seconds() / 3600.0


def dt_local_timezone() -> str:
    return "America/Sao_Paulo"



def dt_is_daylight_saving_time(nanos: int, tz_name: str) -> bool:
    sec = nanos // 1_000_000_000
    tz = _get_tz(tz_name)
    base = _pydt.datetime.fromtimestamp(sec, tz=_pydt.timezone.utc).astimezone(tz)
    dst = base.dst()
    return bool(dst and dst.total_seconds() != 0)


def dt_dst_offset(nanos: int, tz_name: str) -> float:
    sec = nanos // 1_000_000_000
    tz = _get_tz(tz_name)
    base = _pydt.datetime.fromtimestamp(sec, tz=_pydt.timezone.utc).astimezone(tz)
    dst = base.dst()
    if dst is None:
        return 0.0
    return dst.total_seconds() / 3600.0


def dt_monotonic_now() -> int:
    return _pytime.monotonic_ns()


def dt_monotonic_elapsed(start_ns: int) -> int:
    return _pytime.monotonic_ns() - start_ns

