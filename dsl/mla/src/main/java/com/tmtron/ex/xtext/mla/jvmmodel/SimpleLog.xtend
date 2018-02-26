package com.tmtron.ex.xtext.mla.jvmmodel

import org.eclipse.emf.ecore.EObject
import java.util.Stack
import org.eclipse.xtext.xbase.lib.Procedures.Procedure0

class SimpleLog {
	static val Stack<String> ids = new Stack
	var String prefix
	
	public new(String prefix) {
		this.prefix = prefix
	}
	
	def log(String msg) {
		val indentation = ids.fold(new StringBuilder(), [builder, newVal | builder.append('  ')])
		println(prefix+' '+indentation + msg)
	}
	
	def logResources(EObject eObject) {
		eObject.eResource.resourceSet.resources.forEach[res |
			log('res: '+res.URI.lastSegment)
		]		
	}
	
	def indent(String id, Procedure0 proc) {
		enter(id)
		try {
			try {
				proc.apply	
			} catch (Exception e) {
				log('EXCEPTION='+e.class.simpleName+': '+e.message)
				throw e;
			}
		} finally {
			leave()
		}
	}
	
	private def enter(String id) {
		log('+'+id)
		ids.push(id)
	}
	
	private def leave() {
		val id = ids.pop
		log('-'+id)
	}
}