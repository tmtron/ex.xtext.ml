/*
 * generated by Xtext 2.13.0
 */
package com.tmtron.ex.xtext.mla.tests

import com.google.inject.Inject
import com.tmtron.ex.xtext.mla.dslA.ModelA
import com.tmtron.ex.xtext.mla.tests.DslAInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(DslAInjectorProvider) 
class DslAParsingTest {
	@Inject
	ParseHelper<ModelA> parseHelper
	// Helper to test all validation rules and ensure resolved links
	@Inject extension ValidationTestHelper validationTester
	
	@Test def void simpleParsingTest() {
		val parseResult = parseHelper.parse('def fieldA: Long;')
		assertNotNull(parseResult)

		// and read the root instance
		val defs = parseResult.definitionsA
		val defA = defs.head
		// ensure it's not null
		assertNotNull(defA)
		assertEquals('fieldA', defA.name)
		parseResult.assertNoErrors
	}
}
