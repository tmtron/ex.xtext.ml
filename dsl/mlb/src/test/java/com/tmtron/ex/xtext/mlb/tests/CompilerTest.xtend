package com.tmtron.ex.xtext.mlb.tests

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
@InjectWith(DslBInjectorProvider)
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
		package com.tmtron.ex.dsla
		def fieldB: String;
		'''
		.compile[
			checkValidationErrors
			'''
				package com.tmtron.ex.dsla;
				
				@SuppressWarnings("all")
				public class ModelB {
				  private static String fieldB;
				}
			'''.toString
			.assertEquals(getGeneratedCode('com.tmtron.ex.dsla.ModelB'))
			compiledClass
		]
	}

	@Test
	def void testReferences() {
		resourceSet(#[
				"modelA.dsla" -> 
					'''
					package com.tmtron.ex.dsla
					def fieldA: Long;
					''',
				'modelB.dslb' ->
					'''
					package com.tmtron.ex.dsla
					def fieldB: String;
					ref fieldA
					'''
				])
		.compile[
			checkValidationErrors
			'''
				package com.tmtron.ex.dsla;
				
				@SuppressWarnings("all")
				public class ModelB {
				  private static String fieldB;
				  
				  private static Long fieldA;
				}
			'''.toString
			.assertEquals(getGeneratedCode('com.tmtron.ex.dsla.ModelB'))
			compiledClass
		]
	}
	
}
