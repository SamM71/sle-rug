module AST

/*
 * Define Abstract Syntax for QL
 *
 * - complete the following data types
 * - make sure there is an almost one-to-one correspondence with the grammar
 */

data AForm(loc src = |tmp:///|)
  = form(str name, list[AQuestion] questions)
  ; 

data AQuestion(loc src = |tmp:///|)
  = question(str aQuestion, AId name, AType answerType)
  | computedQuestion(str aQuestion, AId name, AType answerType, AExpr answerExpr)
  | block(list[AQuestion] questions) //Delete this??
  | ifThen(AExpr ifExpr, list[AQuestion] questions)
  | ifThenElse(AExpr ifExpr, list[AQuestion] ifQuestions, list[AQuestion] elseQuestions)
  ; 

data AExpr(loc src = |tmp:///|)
  = ref(AId id)
  | boolean(bool b)
  | integer(int i)
  | string(str s)
  | not(AExpr expr)
  | multiply(AExpr lhs, AExpr rhs)
  | divide(AExpr lhs, AExpr rhs)
  | add(AExpr lhs, AExpr rhs)
  | subtract(AExpr lhs, AExpr rhs)
  | greaterThan(AExpr lhs, AExpr rhs)
  | greaterThanOrEqual(AExpr lhs, AExpr rhs)
  | lessThan(AExpr lhs, AExpr rhs)
  | lessThanOrEqual(AExpr lhs, AExpr rhs)
  | equalTo(AExpr lhs, AExpr rhs)
  | notEqual(AExpr lhs, AExpr rhs)
  | logicalAnd(AExpr lhs, AExpr rhs)
  | logicalOr(AExpr lhs, AExpr rhs)
  ;


data AId(loc src = |tmp:///|)
  = id(str name);

data AType(loc src = |tmp:///|)
  = atype(str valType)
  ;