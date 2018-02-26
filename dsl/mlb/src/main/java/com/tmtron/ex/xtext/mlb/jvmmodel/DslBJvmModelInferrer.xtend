/*
 * generated by Xtext 2.13.0
 */
package com.tmtron.ex.xtext.mlb.jvmmodel

import com.google.inject.Inject
import com.tmtron.ex.xtext.mla.jvmmodel.DslAJvmModelInferrer
import com.tmtron.ex.xtext.mlb.dslB.ModelB
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import com.tmtron.ex.xtext.mla.jvmmodel.SimpleLog

/**
 * <p>Infers a JVM model from the source model.</p> 
 *
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>     
 */
class DslBJvmModelInferrer extends AbstractModelInferrer {

	/**
	 * convenience API to build and initialize JVM types and their members.
	 */
	@Inject extension JvmTypesBuilder jvmTypesBuilder
	val SimpleLog sl = new SimpleLog(this.class.simpleName)

	def dispatch void infer(ModelB model, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		sl.indent('infer preIndexing='+isPreIndexingPhase) [
			sl.logResources(model)

			val package = if (model.name !== null) model.name + '.' else ''
			val classname = package + 'ModelB'
			
	 		acceptor.accept(model.toClass(classname)) [
	 			sl.indent('toClass:'+classname) [
		 			model.definitionsB.forEach[definition |
		 				sl.indent('definitions') [
		 					members += DslAJvmModelInferrer.getField(definition, jvmTypesBuilder, sl)
		 				]	 
		 			]
		 			sl.indent('references: '+model.references.size) [
			 			model.references.forEach[ref |
			 				sl.log('ref: '+ref.definition.eIsProxy)
			 				members += DslAJvmModelInferrer.getField(ref.definition, jvmTypesBuilder, sl)
			 			]
		 			]
	 			]
			]
		]
	}
}
