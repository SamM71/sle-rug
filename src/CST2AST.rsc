module CST2AST

import Syntax;
import AST;

import ParseTree;
import String;
import Boolean;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 *
 * - Use switch to do case distinction with concrete patterns (like in Hack your JS) 
 * - Map regular CST arguments (e.g., *, +, ?) to lists 
 *   (NB: you can iterate over * / + arguments using `<-` in comprehensions or for-loops).
 * - Map lexical nodes to Rascal primitive types (bool, int, str)
 * - See the ref example on how to obtain and propagate source locations.
 */

AForm cst2ast(start[Form] sf) {
  Form f = sf.top; // remove layout before and after form
  return form("", [ ], src=f.src); 
}

default AQuestion cst2ast(Question q) {
  switch (q) {
    case qu:(Question)`<Str s> <Id x>: <Type t>`: 
      return question("<s>", id("<x>", src=x@\loc), atype("<t>", src=t@\loc), src=qu@\loc);
    case qu:(Question)`<Str s> <Id x>: <Type t> = <Expr expr>`:
      return computedQuestion("<s>", id("<x>", src=x@\loc), atype("<t>", src=t@\loc), cst2ast(expr), src=qu@\loc);
    case qu:(Question)`{ <Question* questions> }`:
  		return block([cst2ast(question) | Question question <- questions], src=qu@\loc);
    case qu:(Question)`if (<Expr expr>) {<Question* questions>}`: 
      return ifThen(cst2ast(expr), [ cst2ast(question) | Question question <- questions ], src=qu@\loc);
    case qu:(Question)`if (<Expr expr>) {<Question* ifQuestions>} else {<Question* elseQuestions>}`: 
      return ifThenElse(cst2ast(expr), [ cst2ast(question) | Question question <- ifQuestions ], [ cst2ast(question) | Question question <- elseQuestions ], src=qu@\loc);
    default: throw "Question Error";
  }
  
}

AExpr cst2ast(Expr e) {
  switch (e) {
    case ex:(Expr)`<Id x>`: return ref(id("<x>", src=x@\loc), src=ex.src);
    case ex:(Expr)`<Bool b>`: return boolean(fromString("<b>"), src=ex@\loc);
    case ex:(Expr)`<Int i>`: return integer(toInt("<i>"), src=ex@\loc);
    case ex:(Expr)`<Str s>`: return string("<s>", src=ex@\loc);
    case (Expr)`(<Expr expr>)`: return cst2ast(expr);
    case ex:(Expr)`!<Expr expr>`: return not(cst2ast(expr), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> * <Expr rhs>`: return multiply(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> / <Expr rhs>`: return divide(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> + <Expr rhs>`: return add(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> - <Expr rhs>`: return subtract(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> \> <Expr rhs>`: return greaterThan(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> \>= <Expr rhs>`: return greaterThanOrEqual(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> \< <Expr rhs>`: return lessThan(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> \<= <Expr rhs>`: return lessThanOrEqual(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> == <Expr rhs>`: return equalTo(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> != <Expr rhs>`: return notEqual(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> && <Expr rhs>`: return logicalAnd(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    case ex:(Expr)`<Expr lhs> || <Expr rhs>`: return logicalOr(cst2ast(lhs), cst2ast(rhs), src=ex@\loc);
    default: throw "Unhandled expression: <e>";
  }
}

default AType cst2ast(Type t) {
  switch (t) {
    case (Type)`<Str s>`: return atype("<s>", src=s@\loc);
  	default: throw "Type Error";
  };
}
