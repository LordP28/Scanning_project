import { createStore } from 'vuex'

export default createStore({
  state: {
    isAuthenticated: false,
    user: null
  },
  mutations: {
    setAuth(state, status) {
      state.isAuthenticated = status
    },
    setUser(state, user) {
      state.user = user
    }
  },
  actions: {
    login({ commit }, user) {
      commit('setAuth', true)
      commit('setUser', user)
    },
    logout({ commit }) {
      commit('setAuth', false)
      commit('setUser', null)
      localStorage.removeItem('token')
    }
  },
  getters: {
    isAuthenticated: state => state.isAuthenticated,
    user: state => state.user
  }
}) 