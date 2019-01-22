grammar GraphqlSchema;

graphqlSchema
  : (schemaDef|typeDef|inputTypeDef|unionDef|enumDef|interfaceDef|scalarDef|directiveDef)*
  ;

description
  : StringValue
  | BlockStringValue
  ;

schemaDef
  : K_SCHEMA directiveList? '{' operationTypeDef+ '}'
  ;

operationTypeDef
  : queryOperationDef
  | mutationOperationDef
  | subscriptionOperationDef
  ;

queryOperationDef
  : K_QUERY ':' Name
  ;

mutationOperationDef
  : K_MUTATION ':' Name
  ;

subscriptionOperationDef
  : K_SUBSCRIPTION ':' Name
  ;

directiveLocationList
  : (directiveLocation '|')* directiveLocation
  ;

directiveLocation
  : executableDirectiveLocation
  | typeSystemDirectiveLocation
  ;

executableDirectiveLocation
  : 'QUERY' | 'MUTATION' | 'SUBSCRIPTION' | 'FIELD' | 'FRAGMENT_DEFINITION' | 'FRAGMENT_SPREAD'
  | 'INLINE_FRAGMENT'
  ;

typeSystemDirectiveLocation
  : 'SCHEMA' | 'SCALAR' | 'OBJECT' | 'FIELD_DEFINITION' | 'ARGUMENT_DEFINITION'
  | 'INTERFACE' | 'UNION' | 'ENUM' | 'ENUM_VALUE' | 'INPUT_OBJECT' | 'INPUT_FIELD_DEFINITION'
  ;

directiveDef
  : description? K_DIRECTIVE '@' Name argList? K_ON directiveLocationList
  ;


directiveList
  : directive+
  ;

directive
  : '@' Name directiveArgList?
  ;

directiveArgList
  : '(' directiveArg+ ')'
  ;

directiveArg
  : Name ':' value
  ;

typeDef
  : description? K_TYPE anyName implementationDef? directiveList? fieldDefs
  ;

fieldDefs
  : '{' fieldDef+ '}'
  ;

implementationDef
  : K_IMPLEMENTS Name+
  ;

inputTypeDef
  : description? K_INPUT anyName directiveList? fieldDefs
  ;

interfaceDef
  : description? K_INTERFACE Name directiveList? fieldDefs
  ;

scalarDef
  : description? K_SCALAR Name directiveList?
  ;

unionDef
  : description? K_UNION Name directiveList? '=' unionTypes
  ;

unionTypes
  : (Name '|')* Name
  ;

enumDef
  : description? K_ENUM Name directiveList? enumValueDefs
  ;

enumValueDefs
  : '{' enumValueDef+ '}'
  ;

enumValueDef
  : description? Name directiveList?
  ;

fieldDef
  : description? anyName argList? ':' typeSpec directiveList?
  ;

argList
  : '(' argument+ ')'
  ;

argument
  : description? anyName ':' typeSpec defaultValue? directiveList?
  ;

typeSpec
  : (typeName|listType) required?
  ;


/* This is a hook that allows the parser to follow the convention that
   references to default scalar types use a Symbol, not a Keyword. */

typeName
  : Name;

listType
  : '[' typeSpec ']'
  ;

required
  : '!'
  ;

defaultValue
  : '=' value
  ;

anyName
  : nameTokens
  | K_TRUE
  | K_FALSE
  | K_NULL
  ;

nameTokens
  : Name
  | K_TYPE
  | K_IMPLEMENTS
  | K_INTERFACE
  | K_SCHEMA
  | K_ENUM
  | K_UNION
  | K_INPUT
  | K_DIRECTIVE
  | K_EXTEND
  | K_SCALAR
  | K_ON
  | K_FRAGMENT
  | K_QUERY
  | K_MUTATION
  | K_SUBSCRIPTION
  | K_VALUE
  ;

K_TYPE         : 'type'         ;
K_IMPLEMENTS   : 'implements'   ;
K_INTERFACE    : 'interface'    ;
K_SCHEMA       : 'schema'       ;
K_ENUM         : 'enum'         ;
K_UNION        : 'union'        ;
K_INPUT        : 'input'        ;
K_DIRECTIVE    : 'directive'    ;
K_EXTEND       : 'extend'       ;
K_SCALAR       : 'scalar'       ;
K_ON           : 'on'           ;
K_FRAGMENT     : 'fragment'     ;
K_QUERY        : 'query'        ;
K_MUTATION     : 'mutation'     ;
K_SUBSCRIPTION : 'subscription' ;
K_VALUE        : 'value'        ;
K_TRUE         : 'true'         ;
K_FALSE        : 'false'        ;
K_NULL         : 'null'         ;

BooleanValue
    : K_TRUE
    | K_FALSE
    ;

Name
  : [_A-Za-z][_0-9A-Za-z]*
  ;

value
    : IntValue
    | FloatValue
    | StringValue
    | BlockStringValue
    | BooleanValue
    | NullValue
    | enumValue
    | arrayValue
    | objectValue
    ;

enumValue
    : Name
    ;

arrayValue
    : '[' value* ']'
    ;

objectValue
    : '{' objectField* '}'
    ;

objectField
    : Name ':' value
    ;

NullValue
    : K_NULL
    ;

IntValue
    : Sign? IntegerPart
    ;

FloatValue
    : Sign? IntegerPart ('.' Digit+)? ExponentPart?
    ;

Sign
    : '-'
    ;

IntegerPart
    : '0'
    | NonZeroDigit
    | NonZeroDigit Digit+
    ;

NonZeroDigit
    : '1'.. '9'
    ;

ExponentPart
    : ('e'|'E') Sign? Digit+
    ;

Digit
    : '0'..'9'
    ;

StringValue
    : DoubleQuote (~(["\\\n\r\u2028\u2029])|EscapedChar)* DoubleQuote
    ;

BlockStringValue
    : TripleQuote (.)*? TripleQuote
    ;

fragment EscapedChar
    :  '\\' (["\\/bfnrt] | Unicode)
    ;

fragment Unicode
   : 'u' Hex Hex Hex Hex
   ;

fragment DoubleQuote
   : '"'
   ;

fragment TripleQuote
  : '"""'
  ;

fragment Hex
   : [0-9a-fA-F]
   ;

Ignored
   : (Whitespace|Comma|LineTerminator|Comment) -> skip
   ;

fragment Comment
   : '#' ~[\n\r\u2028\u2029]*
   ;

fragment LineTerminator
   : [\n\r\u2028\u2029]
   ;

fragment Whitespace
   : [\t\u000b\f\u0020\u00a0]
   ;

fragment Comma
   : ','
   ;
