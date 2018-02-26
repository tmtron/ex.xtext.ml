package com.tmtron.ex.xtext.mlc.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.xbase.testing.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import org.eclipse.xtext.testing.InjectWith
import org.junit.Rule
import org.eclipse.xtext.xbase.testing.TemporaryFolder
import org.eclipse.xtext.xbase.testing.CompilationTestHelper.Result
import org.eclipse.xtext.diagnostics.Severity

@RunWith(XtextRunner)
@InjectWith(DslCInjectorProvider)
class CompilerTest {
	@Rule
	@Inject
	public TemporaryFolder temporaryFolder
	
	@Inject extension CompilationTestHelper
	
	static def void checkValidationErrors(Result it) {
		val allErrors = getErrorsAndWarnings.filter[severity == Severity.ERROR]
		if (!allErrors.empty) {
			throw new IllegalStateException(
				"One or more resources contained errors : " +
				allErrors.map[toString].join(", ")
			);
		}
	}	

	@Test
	def void testSingleDefinition() {
		'''
			package com.tmtron.ex.dsl
			def fieldC: Integer;
		'''
		.compile[
			checkValidationErrors
			'''
				package com.tmtron.ex.dsl;
				
				@SuppressWarnings("all")
				public class ModelC {
				  private static Integer fieldC;
				}
			'''.toString
			.assertEquals(getGeneratedCode('com.tmtron.ex.dsl.ModelC'))
			compiledClass
		]
	}

@Test
	def void testReferences() {
		resourceSet(#[
				"modelA.dsla" -> 
					'''
					package com.tmtron.ex.dsl
					def fieldA: Long;
					''',
				'modelB.dslb' ->
					'''
					package com.tmtron.ex.dsl
					def fieldB: String;
					ref fieldA
					''',
				'modelC.dslc' ->
					'''
					package com.tmtron.ex.dsl
					def fieldC: Integer;
					ref fieldA
					ref fieldB
					'''					
				])
		.compile[
			checkValidationErrors
			'''
				package com.tmtron.ex.dsl;
				
				@SuppressWarnings("all")
				public class ModelC {
				  private static Integer fieldC;
				  
				  private static Long fieldA;
				  
				  private static String fieldB;
				}
			'''.toString
			.assertEquals(getGeneratedCode('com.tmtron.ex.dsl.ModelC'))
			compiledClass
		]
	}
	
}
