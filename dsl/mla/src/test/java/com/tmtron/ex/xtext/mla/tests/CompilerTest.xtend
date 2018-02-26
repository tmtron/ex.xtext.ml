package com.tmtron.ex.xtext.mla.tests

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
@InjectWith(DslAInjectorProvider)
class CompilerTest {
	@Rule
	@Inject
	public TemporaryFolder temporaryFolder
	
	@Inject extension CompilationTestHelper
	
	@Test
	def void testSingleDefinition() {
		'''
		package com.tmtron.ex.dsla
		
		def fieldA: Long;
		'''
		.compile[
			checkValidationErrors
			'''
			package com.tmtron.ex.dsla;
			
			@SuppressWarnings("all")
			public class ModelA {
			  private static Long fieldA;
			}
			'''.toString.assertEquals(singleGeneratedCode)
			compiledClass
		]
	}
	
	static def void checkValidationErrors(Result it) {
		val allErrors = getErrorsAndWarnings.filter[severity == Severity.ERROR]
		if (!allErrors.empty) {
			throw new IllegalStateException(
				"One or more resources contained errors : " +
				allErrors.map[toString].join(", ")
			);
		}
	}	
	
}
