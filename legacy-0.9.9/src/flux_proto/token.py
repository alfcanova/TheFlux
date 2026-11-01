from enum import Enum, auto
from collections import namedtuple


class TokenType(Enum):
    # Structural
    EOL = auto()
    INDENT = auto()
    DEDENT = auto()
    EOF = auto()

    # Keywords
    WILDCARD = auto()
    MUT = auto()
    IMUT = auto()
    TRUE = auto()
    FALSE = auto()
    STRUCT = auto()
    ENUM = auto()
    CONTRACT = auto()
    IMPL = auto()
    FUNCTION = auto()
    AND_KEYWORD = auto()
    OR_KEYWORD = auto()
    NOT_KEYWORD = auto()
    IN = auto()
    BREAK = auto()
    CONTINUE = auto()
    MATCH = auto()
    ERROR = auto()
    CATCH = auto()
    ENSURE = auto()
    FALLBACK = auto()
    PROGRAM = auto()
    EMIT = auto()
    NICE = auto()
    FAIL = auto()
    ROUTE = auto()
    INFINITE = auto()
    SPLIT = auto()
    JOIN = auto()
    AGENT = auto()
    OP = auto()
    USE = auto()
    OF = auto()
    COMPTIME = auto()
    MACRO = auto()
    QUOTE = auto()
    UNQUOTE = auto()
    ASYNC = auto()
    SPAWN = auto()
    AWAIT = auto()
    KEEP = auto()
    MOVE = auto()
    BORROW = auto()
    UNSAFE = auto()
    PRINT = auto()
    INPUT = auto()
    SPY = auto()
    DATA = auto()
    MAP = auto()
    SET = auto()
    LIST = auto()
    AS = auto()
    BORROW_MUT = auto()
    STATIC = auto()
    EXTERN = auto()

    # Operators — arithmetic
    PLUS = auto()
    MINUS = auto()
    STAR = auto()
    DIV_FLOOR = auto()
    DIV_INT = auto()
    DIV_REM = auto()

    # Operators — power
    POW_REAL = auto()
    POW_RCP = auto()

    # Operators — bitwise
    AND = auto()
    OR = auto()
    XOR = auto()
    TILDE = auto()
    SHIFT_LEFT = auto()
    SHIFT_RIGHT = auto()
    SHIFT_LOGICAL = auto()

    # Operators — relational
    EQEQ = auto()
    NEQ = auto()
    LT = auto()
    GT = auto()
    LTE = auto()
    GTE = auto()

    # Operators — range
    RANGE = auto()

    # Operators — dataflow
    DATAFLOW = auto()
    DATAFLOW_MAP = auto()

    # Operators — prefix
    QUESTION = auto()
    NOT = auto()

    # Operators — postfix
    DOT = auto()
    DOUBLE_COLON = auto()

    # Assignment operators
    EQ = auto()
    ASSIGN_ADD = auto()
    ASSIGN_SUB = auto()
    ASSIGN_MUL = auto()
    ASSIGN_DIVF = auto()
    ASSIGN_DIVI = auto()
    ASSIGN_DIVR = auto()
    ASSIGN_POWE = auto()
    ASSIGN_POWR = auto()
    ASSIGN_AND = auto()
    ASSIGN_OR = auto()
    ASSIGN_XOR = auto()
    ASSIGN_NOT = auto()
    ASSIGN_SHL = auto()
    ASSIGN_SHR = auto()
    ASSIGN_SHRA = auto()

    # Delimiters
    LPAREN = auto()
    RPAREN = auto()
    LBRACE = auto()
    RBRACE = auto()
    LBRACKET = auto()
    RBRACKET = auto()
    COMMA = auto()
    COLON = auto()
    SEMICOLON = auto()

    # Comments & docs
    LINE_COMMENT = auto()
    BLOCK_COMMENT = auto()
    DOCSTRING = auto()

    # Literals
    INT_LIT = auto()
    FLOAT_LIT = auto()
    COMPLEX_LIT = auto()
    DATETIME_LIT = auto()
    STRING_LIT = auto()
    CHAR_LIT = auto()
    INTERPOLATED_STRING_START = auto()
    INTERPOLATION_OPEN = auto()
    INTERPOLATION_CLOSE = auto()
    INTERPOLATED_STRING_END = auto()
    INTERPOLATED_TEXT = auto()

    # Identifiers
    IDENTIFIER = auto()


Token = namedtuple("Token", ["type", "lexeme", "line", "column"])
